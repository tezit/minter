#include "fa2_multi_nft_asset.mligo"


let create_contract : (key_hash option * tez * nft_asset_storage) -> (operation * address) =
  [%Michelson ( {| 
    { 
        UNPPAIIR ; 
        CREATE_CONTRACT 
        { parameter
    (or (or (or %admin (or (unit %confirm_admin) (bool %pause)) (address %set_admin))
            (or %assets
               (or (pair %balance_of
                      (list %requests (pair (address %owner) (nat %token_id)))
                      (contract %callback
                         (list (pair (pair %request (address %owner) (nat %token_id)) (nat %balance)))))
                   (contract %token_metadata_registry address))
               (or (list %transfer
                      (pair (address %from_)
                            (list %txs (pair (address %to_) (pair (nat %token_id) (nat %amount))))))
                   (list %update_operators
                      (or (pair %add_operator (address %owner) (pair (address %operator) (nat %token_id)))
                          (pair %remove_operator (address %owner) (pair (address %operator) (nat %token_id))))))))
        (list %mint
           (pair (pair %metadata
                    (nat %token_id)
                    (pair (string %symbol)
                          (pair (string %name) (pair (nat %decimals) (map %extras string string)))))
                 (address %owner)))) ;
  storage
    (pair (pair %admin (pair (address %admin) (bool %paused)) (option %pending_admin address))
          (pair %assets
             (pair (big_map %ledger nat address) (nat %next_token_id))
             (pair (big_map %operators (pair address (pair address nat)) unit)
                   (big_map %token_metadata
                      nat
                      (pair (nat %token_id)
                            (pair (string %symbol)
                                  (pair (string %name) (pair (nat %decimals) (map %extras string string))))))))) ;
  code { PUSH string "FA2_INSUFFICIENT_BALANCE" ;
         LAMBDA
           (pair address (pair address nat))
           (pair (pair address address) nat)
           { DUP ;
             CDR ;
             CDR ;
             SWAP ;
             DUP ;
             DUG 2 ;
             CAR ;
             DIG 2 ;
             CDR ;
             CAR ;
             PAIR ;
             PAIR } ;
         SWAP ;
         LAMBDA
           (pair string
                 (pair (pair (list (pair (option address) (list (pair (pair nat (option address)) nat))))
                             (lambda
                                (pair (pair address address) (pair nat (big_map (pair address (pair address nat)) unit)))
                                unit))
                       (pair (pair (big_map nat address) nat)
                             (pair (big_map (pair address (pair address nat)) unit)
                                   (big_map nat (pair nat (pair string (pair string (pair nat (map string string))))))))))
           (pair (list operation)
                 (pair (pair (big_map nat address) nat)
                       (pair (big_map (pair address (pair address nat)) unit)
                             (big_map nat (pair nat (pair string (pair string (pair nat (map string string)))))))))
           { DUP ;
             CDR ;
             SWAP ;
             CAR ;
             SWAP ;
             DUP ;
             CDR ;
             DUP ;
             CAR ;
             CAR ;
             SWAP ;
             DUP ;
             DUG 2 ;
             CDR ;
             CAR ;
             PAIR ;
             DIG 2 ;
             DUP ;
             DUG 3 ;
             CAR ;
             CDR ;
             DIG 3 ;
             CAR ;
             CAR ;
             PAIR ;
             PAIR ;
             DUP ;
             CDR ;
             CDR ;
             SWAP ;
             DUP ;
             DUG 2 ;
             CAR ;
             CAR ;
             ITER { DUP ;
                    DUG 2 ;
                    CDR ;
                    ITER { DIG 2 ;
                           DUP ;
                           DUG 3 ;
                           CAR ;
                           IF_NONE
                             { UNIT }
                             { DIG 4 ;
                               DUP ;
                               DUG 5 ;
                               CDR ;
                               CAR ;
                               DIG 2 ;
                               DUP ;
                               DUG 3 ;
                               CDR ;
                               PAIR ;
                               SENDER ;
                               DIG 2 ;
                               PAIR ;
                               PAIR ;
                               DIG 4 ;
                               DUP ;
                               DUG 5 ;
                               CAR ;
                               CDR ;
                               SWAP ;
                               EXEC } ;
                           DROP ;
                           PUSH nat 1 ;
                           SWAP ;
                           DUP ;
                           DUG 2 ;
                           CAR ;
                           CAR ;
                           COMPARE ;
                           GT ;
                           IF { DROP 2 ; DIG 3 ; DUP ; DUG 4 ; FAILWITH }
                              { PUSH nat 0 ;
                                SWAP ;
                                DUP ;
                                DUG 2 ;
                                CAR ;
                                CAR ;
                                COMPARE ;
                                EQ ;
                                IF { DROP }
                                   { DUP ;
                                     DUG 2 ;
                                     CDR ;
                                     DIG 3 ;
                                     DUP ;
                                     DUG 4 ;
                                     CAR ;
                                     PAIR ;
                                     PAIR ;
                                     DUP ;
                                     CDR ;
                                     SWAP ;
                                     DUP ;
                                     DUG 2 ;
                                     CAR ;
                                     CDR ;
                                     DIG 2 ;
                                     CAR ;
                                     CAR ;
                                     IF_NONE
                                       { DROP }
                                       { DIG 2 ;
                                         DUP ;
                                         DUG 3 ;
                                         DIG 2 ;
                                         DUP ;
                                         DUG 3 ;
                                         GET ;
                                         IF_NONE
                                           { DROP 3 ; DIG 4 ; DUP ; DUG 5 ; FAILWITH }
                                           { COMPARE ;
                                             EQ ;
                                             IF { NONE address ; SWAP ; UPDATE }
                                                { DROP 2 ; DIG 4 ; DUP ; DUG 5 ; FAILWITH } } } ;
                                     SWAP ;
                                     DUP ;
                                     DUG 2 ;
                                     CDR ;
                                     DIG 2 ;
                                     CAR ;
                                     CDR ;
                                     PAIR ;
                                     PAIR ;
                                     DUP ;
                                     CDR ;
                                     SWAP ;
                                     DUP ;
                                     DUG 2 ;
                                     CAR ;
                                     CAR ;
                                     IF_NONE
                                       { SWAP ; DROP }
                                       { DIG 2 ; CAR ; CDR ; SWAP ; SOME ; SWAP ; UPDATE } } } } ;
                    SWAP ;
                    DROP } ;
             SWAP ;
             DROP ;
             DIG 2 ;
             DROP ;
             DIP { DUP ; CDR ; SWAP ; CAR ; CDR } ;
             PAIR ;
             PAIR ;
             NIL operation ;
             PAIR } ;
         SWAP ;
         APPLY ;
         LAMBDA
           (pair (pair address bool) (option address))
           unit
           { CAR ;
             CAR ;
             SENDER ;
             COMPARE ;
             NEQ ;
             IF { PUSH string "NOT_AN_ADMIN" ; FAILWITH } { UNIT } } ;
         DIG 3 ;
         DUP ;
         DUG 4 ;
         CDR ;
         DIG 4 ;
         CAR ;
         IF_LEFT
           { IF_LEFT
               { DIG 3 ;
                 DROP ;
                 DIG 3 ;
                 DROP ;
                 SWAP ;
                 DUP ;
                 DUG 2 ;
                 CAR ;
                 SWAP ;
                 IF_LEFT
                   { IF_LEFT
                       { DIG 3 ;
                         DROP 2 ;
                         DUP ;
                         CDR ;
                         IF_NONE
                           { DROP ; PUSH string "NO_PENDING_ADMIN" ; FAILWITH }
                           { SENDER ;
                             COMPARE ;
                             EQ ;
                             IF { CAR ; NONE address ; SWAP ; CDR ; SENDER ; PAIR ; PAIR }
                                { DROP ; PUSH string "NOT_A_PENDING_ADMIN" ; FAILWITH } } ;
                         NIL operation ;
                         PAIR }
                       { SWAP ;
                         DUP ;
                         DUG 2 ;
                         DIG 4 ;
                         SWAP ;
                         EXEC ;
                         DROP ;
                         DIP { DUP ; CDR ; SWAP ; CAR ; CAR } ;
                         SWAP ;
                         PAIR ;
                         PAIR ;
                         NIL operation ;
                         PAIR } }
                   { SWAP ;
                     DUP ;
                     DUG 2 ;
                     DIG 4 ;
                     SWAP ;
                     EXEC ;
                     DROP ;
                     SOME ;
                     SWAP ;
                     CAR ;
                     PAIR ;
                     NIL operation ;
                     PAIR } ;
                 DUP ;
                 DUG 2 ;
                 CDR ;
                 SWAP ;
                 CDR ;
                 SWAP ;
                 PAIR ;
                 SWAP ;
                 CAR ;
                 PAIR }
               { DIG 2 ;
                 DROP ;
                 SWAP ;
                 DUP ;
                 DUG 2 ;
                 CAR ;
                 CAR ;
                 CDR ;
                 IF { PUSH string "PAUSED" ; FAILWITH } { UNIT } ;
                 DROP ;
                 SWAP ;
                 DUP ;
                 DUG 2 ;
                 CDR ;
                 SWAP ;
                 IF_LEFT
                   { DIG 3 ;
                     DROP ;
                     DIG 3 ;
                     DROP ;
                     IF_LEFT
                       { DUP ;
                         CAR ;
                         SWAP ;
                         CDR ;
                         PAIR ;
                         DUP ;
                         CDR ;
                         MAP {} ;
                         SWAP ;
                         CAR ;
                         PAIR ;
                         SWAP ;
                         DUP ;
                         DUG 2 ;
                         CAR ;
                         CAR ;
                         SWAP ;
                         PAIR ;
                         DUP ;
                         CAR ;
                         DUP ;
                         CDR ;
                         MAP { DIG 2 ;
                               DUP ;
                               DUG 3 ;
                               CDR ;
                               SWAP ;
                               DUP ;
                               DUG 2 ;
                               CDR ;
                               GET ;
                               IF_NONE
                                 { DROP ; PUSH string "FA2_TOKEN_UNDEFINED" ; FAILWITH }
                                 { SWAP ;
                                   DUP ;
                                   CAR ;
                                   DIG 2 ;
                                   COMPARE ;
                                   EQ ;
                                   IF { PUSH nat 1 } { PUSH nat 0 } ;
                                   PAIR } ;
                               DUP ;
                               CDR ;
                               CDR ;
                               SWAP ;
                               DUP ;
                               DUG 2 ;
                               CDR ;
                               CAR ;
                               PAIR ;
                               SWAP ;
                               CAR ;
                               SWAP ;
                               PAIR } ;
                         DIG 2 ;
                         DROP ;
                         SWAP ;
                         CAR ;
                         PUSH mutez 0 ;
                         DIG 2 ;
                         TRANSFER_TOKENS ;
                         SWAP ;
                         NIL operation ;
                         DIG 2 ;
                         CONS ;
                         PAIR }
                       { PUSH mutez 0 ;
                         SELF ;
                         ADDRESS ;
                         TRANSFER_TOKENS ;
                         SWAP ;
                         NIL operation ;
                         DIG 2 ;
                         CONS ;
                         PAIR } }
                   { IF_LEFT
                       { DIG 4 ;
                         DROP ;
                         MAP { DUP ;
                               CDR ;
                               MAP { DUP ;
                                     CDR ;
                                     CAR ;
                                     SWAP ;
                                     DUP ;
                                     DUG 2 ;
                                     CAR ;
                                     DIG 2 ;
                                     CDR ;
                                     CDR ;
                                     PAIR ;
                                     PAIR } ;
                               SWAP ;
                               CAR ;
                               PAIR } ;
                         MAP { DUP ;
                               CDR ;
                               MAP { DUP ;
                                     CDR ;
                                     SWAP ;
                                     DUP ;
                                     DUG 2 ;
                                     CAR ;
                                     CDR ;
                                     SOME ;
                                     DIG 2 ;
                                     CAR ;
                                     CAR ;
                                     PAIR ;
                                     PAIR } ;
                               SWAP ;
                               CAR ;
                               SOME ;
                               PAIR } ;
                         SWAP ;
                         LAMBDA
                           (pair (pair address address) (pair nat (big_map (pair address (pair address nat)) unit)))
                           unit
                           { DUP ;
                             CAR ;
                             CAR ;
                             SWAP ;
                             DUP ;
                             DUG 2 ;
                             CAR ;
                             CDR ;
                             DUP ;
                             DIG 2 ;
                             DUP ;
                             DUG 3 ;
                             COMPARE ;
                             EQ ;
                             IF { DROP 3 ; UNIT }
                                { DIG 2 ;
                                  DUP ;
                                  DUG 3 ;
                                  CDR ;
                                  CDR ;
                                  DIG 3 ;
                                  CDR ;
                                  CAR ;
                                  DIG 2 ;
                                  PAIR ;
                                  DIG 2 ;
                                  PAIR ;
                                  MEM ;
                                  IF { UNIT } { PUSH string "FA2_NOT_OPERATOR" ; FAILWITH } } } ;
                         DIG 2 ;
                         PAIR ;
                         PAIR ;
                         DIG 2 ;
                         SWAP ;
                         EXEC }
                       { DIG 3 ;
                         DROP ;
                         SWAP ;
                         DUP ;
                         DUG 2 ;
                         CDR ;
                         CAR ;
                         SWAP ;
                         PAIR ;
                         DUP ;
                         CAR ;
                         MAP { IF_LEFT
                                 { LEFT (pair (address %owner) (pair (address %operator) (nat %token_id))) }
                                 { RIGHT (pair (address %owner) (pair (address %operator) (nat %token_id))) } ;
                               IF_LEFT
                                 { DIG 4 ;
                                   DUP ;
                                   DUG 5 ;
                                   SWAP ;
                                   EXEC ;
                                   LEFT (pair (pair (address %operator) (address %owner)) (nat %token_id)) }
                                 { DIG 4 ;
                                   DUP ;
                                   DUG 5 ;
                                   SWAP ;
                                   EXEC ;
                                   RIGHT (pair (pair (address %operator) (address %owner)) (nat %token_id)) } } ;
                         DIG 4 ;
                         DROP ;
                         SENDER ;
                         DIG 2 ;
                         CDR ;
                         DIG 2 ;
                         ITER { SWAP ;
                                PAIR ;
                                DUP ;
                                CDR ;
                                DIG 2 ;
                                DUP ;
                                DUG 3 ;
                                SWAP ;
                                DUP ;
                                DUG 2 ;
                                IF_LEFT {} {} ;
                                CAR ;
                                CDR ;
                                COMPARE ;
                                EQ ;
                                IF { UNIT } { PUSH string "FA2_NOT_OWNER" ; FAILWITH } ;
                                DROP ;
                                SWAP ;
                                CAR ;
                                SWAP ;
                                IF_LEFT
                                  { SWAP ;
                                    UNIT ;
                                    SOME ;
                                    DIG 2 ;
                                    DUP ;
                                    DUG 3 ;
                                    CDR ;
                                    DIG 3 ;
                                    DUP ;
                                    DUG 4 ;
                                    CAR ;
                                    CAR ;
                                    PAIR ;
                                    DIG 3 ;
                                    CAR ;
                                    CDR ;
                                    PAIR ;
                                    UPDATE }
                                  { DUP ;
                                    DUG 2 ;
                                    CDR ;
                                    DIG 2 ;
                                    DUP ;
                                    DUG 3 ;
                                    CAR ;
                                    CAR ;
                                    PAIR ;
                                    DIG 2 ;
                                    CAR ;
                                    CDR ;
                                    PAIR ;
                                    NONE unit ;
                                    SWAP ;
                                    UPDATE } } ;
                         SWAP ;
                         DROP ;
                         DIP { DUP ; CAR ; SWAP ; CDR ; CDR } ;
                         PAIR ;
                         SWAP ;
                         PAIR ;
                         NIL operation ;
                         PAIR } } ;
                 DUP ;
                 DUG 2 ;
                 CDR ;
                 SWAP ;
                 CAR ;
                 PAIR ;
                 SWAP ;
                 CAR ;
                 PAIR } }
           { DIG 4 ;
             DROP ;
             SWAP ;
             DUP ;
             DUG 2 ;
             CAR ;
             DIG 3 ;
             SWAP ;
             EXEC ;
             DROP ;
             SWAP ;
             DUP ;
             DUG 2 ;
             CDR ;
             SWAP ;
             PAIR ;
             DUP ;
             CDR ;
             NIL (pair (pair nat (option address)) nat) ;
             PAIR ;
             SWAP ;
             CAR ;
             ITER { DUP ;
                    CAR ;
                    CAR ;
                    SWAP ;
                    DUP ;
                    DUG 2 ;
                    CAR ;
                    CDR ;
                    CAR ;
                    DIG 2 ;
                    DUP ;
                    DUG 3 ;
                    CAR ;
                    CDR ;
                    CDR ;
                    CAR ;
                    PAIR ;
                    DIG 2 ;
                    DUP ;
                    DUG 3 ;
                    CAR ;
                    CDR ;
                    CDR ;
                    CDR ;
                    CDR ;
                    DIG 3 ;
                    DUP ;
                    DUG 4 ;
                    CAR ;
                    CDR ;
                    CDR ;
                    CDR ;
                    CAR ;
                    PAIR ;
                    PAIR ;
                    PAIR ;
                    DIG 2 ;
                    DUP ;
                    DUG 3 ;
                    CDR ;
                    CAR ;
                    CDR ;
                    SWAP ;
                    DUP ;
                    DUG 2 ;
                    CDR ;
                    COMPARE ;
                    LT ;
                    IF { DROP 3 ; PUSH string "FA2_INVALID_TOKEN_ID" ; FAILWITH }
                       { DIG 2 ;
                         DUP ;
                         DUG 3 ;
                         CDR ;
                         DIG 3 ;
                         DUP ;
                         DUG 4 ;
                         CDR ;
                         CDR ;
                         CDR ;
                         DIG 3 ;
                         DUP ;
                         DUG 4 ;
                         CAR ;
                         DIG 3 ;
                         DUP ;
                         DUG 4 ;
                         CDR ;
                         SWAP ;
                         SOME ;
                         SWAP ;
                         UPDATE ;
                         DIP { DUP ; CAR ; SWAP ; CDR ; CAR } ;
                         SWAP ;
                         PAIR ;
                         SWAP ;
                         PAIR ;
                         PUSH nat 1 ;
                         DIG 2 ;
                         DUP ;
                         DUG 3 ;
                         CDR ;
                         ADD ;
                         DIP { DUP ; CDR ; SWAP ; CAR ; CAR } ;
                         SWAP ;
                         PAIR ;
                         PAIR ;
                         DIG 3 ;
                         CAR ;
                         DIG 2 ;
                         CDR ;
                         DIG 3 ;
                         CDR ;
                         SOME ;
                         PUSH nat 1 ;
                         PAIR ;
                         PAIR ;
                         CONS ;
                         PAIR } } ;
             DUP ;
             CDR ;
             LAMBDA
               (pair (pair address address) (pair nat (big_map (pair address (pair address nat)) unit)))
               unit
               { DROP ; UNIT } ;
             NIL (pair (option address) (list (pair (pair nat (option address)) nat))) ;
             DIG 3 ;
             CAR ;
             NONE address ;
             PAIR ;
             CONS ;
             PAIR ;
             PAIR ;
             DIG 2 ;
             SWAP ;
             EXEC ;
             DUP ;
             DUG 2 ;
             CDR ;
             SWAP ;
             CAR ;
             PAIR ;
             SWAP ;
             CAR ;
             PAIR } } }


        ; 
        PAIR 
    } 
  |} : (key_hash option * tez * nft_asset_storage) -> (operation * address))]


let factory_main (admin, storage : address * unit) : operation list * unit =
  let init_storage : nft_asset_storage = {
    assets = {
      ledger = (Big_map.empty : ledger);
      token_metadata = (Big_map.empty : nft_meta);
      next_token_id = 0n;
      operators = (Big_map.empty : operator_storage);
    };
    admin = {
      admin = Tezos.sender;
      pending_admin = (None : address option);
      paused = false;
    };
  } in
 let op, a = create_contract ((None: key_hash option), 0tez, init_storage) in
 [op], storage