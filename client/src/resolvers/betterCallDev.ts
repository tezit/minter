import axios, { AxiosError } from 'axios';
import axiosRetry from 'axios-retry';
import { isNil } from 'lodash';

import selectObjectByKeys from '../utils/selectObjectByKeys';

export type Address = string;

export interface BaseContract {
  address: Address;
  manager: Address;
  storage: any;
}

export interface GenericContract extends BaseContract {
  contractType: 'GenericContract';
}

export interface FA2FactoryContract extends BaseContract {
  contractType: 'FA2FactoryContract';
  address: Address;
  manager: Address;
  contractsBigMapId: number;
}

export interface FA2Contract extends BaseContract {
  contractType: 'FA2Contract';
  bigMaps: {
    ledger: number;
    operators: number;
    token_metadata: number;
  };
}
export type Contract = FA2Contract | FA2FactoryContract | GenericContract;
export interface Operation {
  hash: string;
  status: 'applied' | 'failed' | 'skipped' | 'backtracked';
  timestamp: string;
  errors: [any] | undefined;
}

export interface BigMapItem<T> {
  key: string;
  value: T;
}

function gatherBigMapChildren(children: any) {
  return children.reduce((acc: any, v: any) => {
    const value =
      v.value !== undefined ? v.value : gatherBigMapChildren(v.children);
    return { ...acc, [v.name]: value };
  }, {});
}

export const BigMap = <T>(baseUrl: string, network: string, id: number) => ({
  async values(): Promise<BigMapItem<T>[]> {
    const resp = await axios.get(`${baseUrl}/v1/bigmap/${network}/${id}/keys`);
    return resp.data.map((i: any) => {
      const { value, children } = i.data.value;
      return {
        key: i.data.key_string,
        value: value !== undefined ? value : gatherBigMapChildren(children)
      };
    });
  }
});

function selectBigMap(storage: any, name: string) {
  return selectObjectByKeys(storage, { type: 'big_map', name });
}

// TODO: This function should return various well-typed contracts based on their
// metadata, which relies on TZIP-16 support
export async function contractByAddress(
  baseUrl: string,
  network: string,
  address: string
): Promise<Contract> {
  const contractUrl = `${baseUrl}/v1/contract/${network}/${address}`;
  const contract = (await axios.get(contractUrl)).data;
  const storage = (await axios.get(`${contractUrl}/storage`)).data;
  const manager = contract.manager;

  const baseContract = { address, manager, storage };

  const ledger = selectBigMap(storage, 'ledger')?.value;
  const operators = selectBigMap(storage, 'operators')?.value;
  const token_metadata = selectBigMap(storage, 'token_metadata')?.value;

  if ([ledger, operators, token_metadata].every((i: any) => !isNil(i))) {
    return {
      ...baseContract,
      contractType: 'FA2Contract',
      bigMaps: {
        ledger,
        operators,
        token_metadata
      }
    };
  }

  const contractsBigMapId = storage.value;

  if (!isNil(contractsBigMapId) && typeof storage.value === 'number') {
    return {
      ...baseContract,
      contractType: 'FA2FactoryContract',
      contractsBigMapId
    };
  }

  return { ...baseContract, contractType: 'GenericContract' };
}

axiosRetry(axios, { retries: 3 });

interface Stats {
  chainId: string;
  hash: string;
  level: number;
  network: string;
  predecessor: string;
  protocol: string;
  timestamp: string;
}

export const mkBetterCallDev = (baseUrl: string, network: string) => ({
  async stats(): Promise<Stats[]> {
    type BcdStats = Omit<Stats, 'chainId'> & { chain_id: string };
    const r = await axios.get<BcdStats[]>(`${baseUrl}/v1/stats`);
    return r.data.map(s => ({ chainId: s.chain_id, ...s }));
  },

  contractByAddress(address: string) {
    return contractByAddress(baseUrl, network, address);
  },

  bigMapById<T>(id: number) {
    return BigMap<T>(baseUrl, network, id);
  },

  async contractOperation(
    contractAddress: string,
    hash: string,
    since?: string
  ): Promise<Operation | undefined> {
    try {
      const from = since ? `?from=${new Date(since).getTime()}` : '';

      const operations = await axios.get<{ operations: Operation[] }>(
        `${baseUrl}/v1/contract/${network}/${contractAddress}/operations${from}`,
        {
          'axios-retry': {
            retries: 0
          }
        }
      );

      return operations.data.operations.find((o: any) => o.hash === hash);
    } catch (e) {
      if ((e as AxiosError).response?.status === 500) return undefined;
      else throw e;
    }
  }
});

export type BetterCallDev = ReturnType<typeof mkBetterCallDev>;
