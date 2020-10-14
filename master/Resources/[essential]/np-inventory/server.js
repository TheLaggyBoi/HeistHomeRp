let DroppedInventories = [];
let InUseInventories = [];
let DataEntries = 0;
let hasBrought = [];
let CheckedDeginv = [];
const DROPPED_ITEM_KEEP_ALIVE = 1000 * 60 * 15; // 15 MINUTES
// check above and all right 

function clean() {
    for (let Row in DroppedInventories) {
        if (new Date(DroppedInventories[Row].lastUpdated + DROPPED_ITEM_KEEP_ALIVE).getTime() < Date.now() && DroppedInventories[Row].used && !InUseInventories[DroppedInventories[Row].name]) {
            emitNet("Inventory-Dropped-Remove", -1, [DroppedInventories[Row].name])
            delete DroppedInventories[Row];
        }
    }
}

setInterval(clean, 20000)

function CleanDroppedInventory() {
    onNet("server-ragdoll-items", async (player) => {
        let currInventoryName = `${player}`
        let newInventoryName = `wait-${player}`
   
        db(`UPDATE user_inventory2 SET name='${newInventoryName}', WHERE name='${currInventoryName}' and dropped=0 and item_id="mobilephone" `);
        db(`UPDATE user_inventory2 SET name='${newInventoryName}', WHERE name='${currInventoryName}' and dropped=0 and item_id="idcard" `);
   
        await db(`DELETE FROM user_inventory2 WHERE name='${currInventoryName}'`);
   
        db(`UPDATE user_inventory2 SET name='${currInventoryName}', WHERE name='${newInventoryName}' and dropped=0`);
        db(`DELETE FROM user_inventory2 WHERE dropped='1'`);
        db(`DELETE FROM user_inventory2 WHERE name='trash-1'`);
        db(`DELETE FROM user_inventory2 WHERE item_id IN ('foodingredient', 'coffee', 'fishtaco', 'taco', 'burrito', 'churro', 'hotdog', 'greencow', 'donut', 'eggsbacon', 'icecream', 'mshake')`)
        db(`UPDATE user_inventory2 SET name='${newInventoryName}', WHERE name='${currInventoryName}' and dropped=0 and item_id="bandage" `);
        db(`UPDATE user_inventory2 SET name='${newInventoryName}', WHERE name='${currInventoryName}' and dropped=0 and item_id="idcard" `);

    })
};

function db(string) {
    exports.ghmattimysql.execute(string,{}, function(result) {
    });
}

setTimeout(CleanDroppedInventory, 5)

function sendClientItemList(src)
{
    emitNet('inv:sendItemList',src,itemList)
}


//dropped items and checked.
function DroppedItem(itemArray) {
    itemArray = JSON.parse(itemArray)
    var shopItems = [];

    shopItems[0] = { item_id: itemArray[0].itemid, id: 0, name: "shop", information: "{}", slot: 1, amount: itemArray[0].amount};

    return JSON.stringify(shopItems);
}
function BuildInventory(Inventory) {
    let buildInv = Inventory
    let invArray = {};
    itemCount = 0;
    for (let i = 0; i < buildInv.length; i++) {
        invArray[itemCount] = { item_id: buildInv[i].item_id, id: buildInv[i].id, name: buildInv[i].name, information: buildInv[i], slot: buildInv[i].slot};
        itemCount = itemCount + 1
    }
    return [JSON.stringify(invArray),itemCount]
}

function mathrandom(min, max) {
    return Math.floor(Math.random() * (max+1 - min) ) + min;
}
// checked all above all right ^^^^ :) stream 45:56


const DEGREDATION_INVENTORY_CHECK = 1000 * 60 * 60;
const DEGREDATION_TIME_BROKEN = 1000 * 60 * 40320;
const DEGREDATION_TIME_WORN = 1000 * 60 * 201000;

// function inventoryDegredation(invname, inventory) {
//     let dateNow = Date.now()
//     if (CheckedDeginv[invName]) {
//         if(new Date(CheckedDeginv[invName] * DEGREDATION_INVENTORY_CHECK).getTime() > dateNow)
//         return
//     }
    
//     CheckedDeginv[invName] = Date.now()
//     let sqlUpdateInformation = "UPDATE user_inventory2 SET information = (case ";
//     let sqlUpdateInformationID = "";
//     let weaponUpdate = false;

    

//     let updatedInventory = inventory


//     for (let i = 0; i < updatedInventory.length; i++) {
//         let itemID = updatedInventory[i].item_id
//         if(itemList[itemID] != undefined && itemList[itemID].deg) 
//         {
//             if(itemList[itemID].weapon)
//             {
//                 let information = JSON.parse(updatedInventory[i].information)
//                 if (information.quality == "" || information.quality == null || updatedInventory[i].creationDate == null) {
//                     updatedInventory[i].creationDate = dataNow
//                     information.quality = "Alter"
//                     exports.ghmattimysql.execute(`UPDATE user_inventory2 SET creationDate = ${updatedInventory[i].creationDate} WHERE id = ${updatedInventory[i].id}`,{}, function() {});
//                 }


//                 if(information.quality != "broken")
//                 {
//                     let currentQuality = "Good"

//                     if(new Date(updatedInventory[i].creationDate + DEGREDATION_TIME_WORN).getTime() < dateNow)
//                          currentQuality = "Worn"
//                     if (new Date(updatedInventory[i],creationDate + DEGREDATION_TIME_POOR).getTime() < dateNow)
//                          currentQuality = "Poor"
//                     if (new Date(updatedInventory[i].creationDate + DEGREDATION_TIME_BROKEN).getTime() < dateNow)
//                          currentQuality = "Broken"
//                     if(information.quality == "Alter") //or +=???
//                          currentQuality = "Good"

//                     if(information.quality != currentQuality)
//                     {
//                         information.quality = currentQuality;
//                         sqlUpdateInformation = sqlUpdateInformation+ `when id = ${updatedInventory[i].id} then '${JSON.stringify(information)}' `
//                         sqlUpdateInformationID = sqlUpdateInformationID+'${updatedInventory[i].id},'
//                         updatedInventory[i].information = JSON.stringify(information)
//                         weaponUpdate = true
//                     }
//                 }
//             }
//             else
//             {
//                 //
//             }
//         }
//     }

// //////////////////////////////////////
//     if(weaponUpdate)
//     {
//         sqlUpdateInformation = sqlUpdateInformation-`END) WHERE id IN (${sqlUpdateInformationID}0);`
//         exports.ghmattimysql.execute(sqlUpdateInformation,{}, function() {});
//         return updatedInventory
//     }

// } 
// //////////////////
// function cleanCurrentDegInventory () {
//        let dateNow = Date.now()
//        for (let Row in CheckedDeginv) {
//            if(new Date(CheckedDeginv[Row] + DEGREDATION_INVENTORY_CHECK).getTime() > dateNow)
//            {
//                delete CheckedDeginv[Row]
//            }
//        }
// }

// setInterval(cleanCurrentDegInventory, 1000 * 60 * 30)

RegisterServerEvent("inventory:degItem")
onNet("inventory:degItem", async (itemID,amount) => {
    exports.ghmattimysql.excute(`UPDATE user_inventory2 SET creationDate = creationDate - ${amount} WHERE id = ${itemID}`, {}, function() {});
});

RegisterServerEvent('stores:pay:cycle')
onNet('store:pay:cycle', async (storeList) => {

   storeList = JSON.parse(storeList)
   for (let key in storeList) {

       if (storeList[key].house_model == 4) {
           let trap = storeList[key]["trap"]
           let id = storeList[key]["dbid"]
           let name = storeList[key]["stash"]
           let storeName = storeList[key]["name"]
           let reputation = storeList [key]["reputation"]
           let luckyslot = 1
           let luckroll = mathrandom(1,100)
           let amount = 1
           let inventoryType = 'house_information'

           if (trap) {
               inventoryType = 'trap_houses'
           }

           let itemid = 0 
           let rolled = reputation + luckroll
           if (rolled > 96) {

           if (rolled > 120) {
               amount = 2
           }
           if (rolled > 150) {
               amount = 3
           }
           if (rolled > 180) {
               amount = 4
           }
           if (rolled > 149) {
               amount = 7
           }

           if (amount > 0) {
               let slot = mathrandom(1,2)
               let string = `SELECT item_id FROM user_inventory2 WHERE name = '${name}' and slot = '${slot}'`;
               exports.ghmattimysql.execute(string,{}, function(inventory) {
                   if (inventory.length > 0) {
                       emitNet("ai:storewalkout",-1,key)
                       if (amount > inventory.length) {
                           amount = inventory.length
                       }

                       let string = `DELETE FROM user_inventory2 WHERE name='${name}' and slot = '${slot}' LIMIT ${amount}`;

                       exports.ghmattimysql.execute(string,{}, function() {});

                       let itemid = inventory[0].item_id
                       let sellValue = itemList[itemid].price * amount

                       if (reputation < 10) {
                           sellValue = sellValue * 0.5
                       } else if (reputation < 20) {
                        sellValue = sellValue * 0.55
                       } else if (reputation < 30) {
                        sellValue = sellValue * 0.6
                       } else if (reputation < 50) {
                        sellValue = sellValue * 0.65
                       } else if (reputation < 70) {
                        sellValue = sellValue * 0.75
                       } else if (reputation < 80) {
                        sellValue = sellValue * 0.8
                       } else if (reputation < 90) {
                        sellValue = sellValue * 0.9
                       }

                       sellValue = Math.ceil(sellValue)

                       payStore(name,sellValue,itemid)
                       if (rolled == 100 && itemList[itemid].illegal) {
                           reputation = reputation + 1
                           if (reputation < 100) {
                               let string = `UPDATE ${inventoryType} SET reputation='${reputation}' WHERE id='${id}'`
                               exports.ghmattimysql.execute(string,{}, function() {});
                           }
                       }
                   } else {
                       if (reputation > 0 && mathrandom(1,100) > 98) {
                           reputation = reputation - 1
                            let string = `UPDATE ${inventoryType} SET reputation='${reputation}' WHERE id='${id}'`
                           exports.ghmattimysql.execute(string,{},function() {});
                       }
                   }
               });
           }
       }
   }
}
});


RegisterServerEvent("server-remove-item")
onNet("server-remove-item", async (player,itemidsent,amount,openedInv) => {
    functionRemoveAny(player, itemidsent, amount, openedInv)
});

RegisterServerEvent("server-update-item")
onNet("server-update-item", async (player, itemidsent,slot,data) => {
    let src = source
    let playerinvname = player
    let string = `UPDATE user_inventory2 SET information='${data}' WHERE item_id='${itemidsent}' and name='${playerinvname}' and slot='${slot}'`

    exports.ghmattimysql.execute(string,{}, function() {
        emit("server-request-update-src",player,src)
        print(string)
        print("UPDATING ITEM?")
    });
});

function functionRemoveAny(player, itemidsent, amount, openedInv) {
    let src = source
    let playerinvname = player
    let string = `DELETE FROM user_inventory2 WHERE name='${playerinvname}' and item_id='${itemidsent}' LIMIT ${amount}`

    exports.ghmattimysql.execute(string,{},function() {
        emit("server-request-update-src",player,src)
    });
}

RegisterServerEvent("request-dropped-items")
onNet("request-dropped-items", async (player) => {
    let src = source;
    emitNet("requested-dropped-items", src, JSON.stringify(Object.assign({},DroppedInventories)));
});

RegisterServerEvent("server-request-update")
onNet("server-request-update", async (player) => {
    let src = source
    let playerinvname = player
    let string = `SELECT count(item_id) as amount, item_id, name, information, slot, dropped FROM user_inventory2 WHERE name ='${player}' group by item_id, slot`;// slot
    exports.ghmattimysql.execute(string, {}, function(inventory) {
        emitNet("inventory-update-player", src, [inventory,0,playerinvname]);
    });
});

RegisterServerEvent("server-request-update-src")
onNet("server-request-update-src", async (player,src) => {
    let playerinvname = player // or < or *
    let string = `SELECT count(item_id) as amount, item_id, name, information, slot, dropped FROM user_inventory2 WHERE name ='${player}' group by item_id, slot`; // slot
    exports.ghmattimysql.execute(string, {}, function(inventory) {
        emitNet("inventory-update-player", src, [inventory,0,playerinvname]);
    });
});

function makeid(length) {
    var result           = '';
    var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghikjlmnopqrstuvwxyz'; //abcdef
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
        result += characters.charAt(Math.floor(Math.random() * charactersLength));
    }
    return result;
}

// checked above 1 hour 2 minutes

function GenerateInformation(player,itemid,itemdata) {
    let data = Object.assign({}, itemdata);
    let returnInfo = "{}"

    return new Promise((resolve, reject) => {
    if (itemid == "") return resolve(returninfo);
    let timeout = 0;
    if (!isNaN(itemid)) {
        var identifier = player.toString()
        if(itemdata && itemdata.fakeWeaponData) {
            identifier = Math.floor((Math.random() * 99999) + 1)
            identifier = identifier.toString()
        }

        let cartridgeCreated = player + "-" + makeid(3) + "-" + Math.floor((Math.random() * 999) + 1);
        returnInfo = JSON.stringify({ cartridge: cartridgeCreated, serial: identifier})
        timeout = 1;
        clearTimeout(timeout)
        return resolve(returnInfo);
    } else if (Object.prototype.toString.call(itemid) ===  '[object String]') {
        switch(itemid.toLowerCase()) {
          case "idcard":
          if(itemdata == itemdata.fake){
              returnInfo = JSON.stringify({
                  identifier: itemdata, charID,
                  Name: itemdata.first.replace(/[^\w\s]/gi, ''),
                  Surname: itemdata.last.replace(/[^\w\s]/gi, ''),
                  Sex: itemdata.sex,
                  DOB: itemdata.dob })
                  timeout = 1
                  clearTimeout(timeout)
                  return resolve(returnInfo);
              } else {
                  let string = `SELECT first_name,last_name,gender,dob FROM characters WHERE id = '${player}'`;
                  exports.ghmattimysql.execute(string,{}, function(result) {
                      returnInfo = JSON.stringify({
                          identifier: player.toString(),
                          Name: result[0].first_name.replace(/[^\w\s]/gi, ''),
                          Surname: result[0].last_name.replace(/[^\w\s]/gi, ''),
                          Sex: result[0].gender,
                          DOB: result[0].dob })
                          timeout = 1
                          clearTimeout(timeout)
                          return resolve(returnInfo);
                      });
                    }
                    break;
                 case "casing":
                        returnInfo = JSON.stringify({ Identifier: itemdata.identifier, type: itemdata.eType, other: itemdata.other})
                        timeout = 1
                        clearTimeout(timeout)
                        return resolve(returnInfo);
                    case "evidence":
                        returnInfo = JSON.stringify({ Identifier:itemdata.identifier, type: itemdata.eType, other: itemdata.other })
                        timeout = 1;
                        clearTimeout(timeout)
                        return resolve(returnInfo);
                    case "drivingtest":
                         if (data.id) {
                            let string = `SELECT * FROM driving_tests WHERE id = '${data.id}'`;
                            exports.ghmattimysql.execute(string, {}, function(result) {
                                if (result[0]) {
                                    let ts = new Date(parseInt(result[0].timestamp) * 1000)
                                    let testDate = ts.getFullYear() + "-" + ("0"+(ts.getMonth()+1)).slice(-2) + "-" + ("0" + ts.getDate()).slice(-2)
                                    returninfo = JSON.stringify({ ID: result[0].id, CID: result[0].cid, Instructor: result[0].instructor, Date: testdata })
                                    timeout = 1;
                                    clearTimeout(timeout)
                                }
                                return resolve(returninfo);
                            });
                        } else {
                            timeout = 1;
                            clearTimeout(timeout)
                            return resolve(returnInfo);
                        }
                        break;
                    default:
                            timeout = 1
                            clearTimeout(timeout)
                            return resolve(returnInfo);
                        }
                    } else {
                        return resolve(returnInfo);
                    }

                    setTimeout(() => {
                        if (timeout == 0) {
                            return resolve(returnInfo);
                        }
                     },500)
            });
    }
// checked
RegisterServerEvent("server-inventory-give")
onNet("server-inventory-give", async (player, itemid, slot, amount, generateInformation, itemdata, openedInv) => {
    let src = source
    let playerinvname = player
    let information = "{}"
    let creationDate = Date.now()
    if (generateInformation) {
        information = await GenerateInformation(player,itemid,itemdata)
    }
        let values = `('${playerinvname}','${itemid}','${information}','${slot}','${creationDate}')`
        if (amount > 1) {
            for (let i = 2; i <= amount; i++) {
                values = values + `,('${playerinvname}','${itemid}','${information}','${slot}','${creationDate}')`
            }
        }

        let query = `INSERT INTO user_inventory2 (name,item_id,information,slot,creationDate) VALUES ${values};`
        exports.ghmattimysql.execute(query,{},function() {
            emit("server-request-update-src",player,src)
        });
});


RegisterServerEvent("server-inventory-open")
onNet("server-inventory-open", async ( coords, player, secondInventory, targetName, itemToDropArray, sauce) => {
    let src = source

    if (!src) {
        src = sauce 
    }

    let playerinvname = player

    if ( InUseInventories[targetName] || InUseInventories[playerinvname] ) {
        if (InUseInventories[playerinvname]) {
            if ( ( InUseInventories[playerinvname] != player ) ) {
                return
            } else {
               
            }
        }
        if (InUseInventories[targetName]) {
            if (InUseInventories[targetName] == player) {

            } else {
                secondInventory = "69"
            }
        }
    }
    sendClientItemList(src)
    let string = `SELECT count(item_id) as amount, name, item_id, information, slot, dropped, creationDate FROM user_inventory2 where name= '${player}' group by item_id`;

    exports.ghmattimysql.execute(string,{}, function(inventory) {

        var invArray = inventory;
        var i;
        var arrayCount = 0;

           InUseInventories[playerinvname] = player;

           if(secondInventory == "1") {
               var targetinvname = targetName

               let string = `SELECT count(item_id) as amount, name, item_id, information, slot, dropped, creationDate FROM user_inventory2 WHERE name = '${targetinvname}' group by item_id`;
               exports.ghmattimysql.execute(string,{}, function(inventory2) { 
                       emitNet("inventory-open-target", src, [invArray, arrayCount,playerinvname,inventory2,0,targetinvname,500,true]);
                       InUseInventories[targetinvname] = player
               });

           } else if (secondInventory == "3") {
               let Key = ""+DataEntries+"";
               let NewDroppedName = 'Drop-' + Key;

               DataEntries = DataEntries + 1
               var invArrayTarget = [];
               DroppedInventories[NewDroppedName] = { position: { x: coords[0], y: coords[1], z: coords[2] }, name: NewDroppedName, used: false, lastUpdated: Date.now() }


               InUseInventories[NewDroppedName] = player;
               invArrayTarget = JSON.stringify(invArrayTarget)
               emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,invArrayTarget,0,NewDroppedName,500,false]);
}
 else if (secondInventory == "13")
{
 
     let Key = ""+DataEntries+"";
     let NewDroppedName = 'Drop-'  + Key;
     DataEntries = DataEntries + 1
       for (let Key in itemToDropArray) {
           for (let i = 0; i < itemToDropArray[Key].length; i++) {
               let objectToDrop = itemToDropArray[Key][i];
               db(`UPDATE user_inventory2 SET slot='${i+1}', name='${NewDroppedName}', dropped='1' WHERE name='${Key}' and slot='${objectToDrop.faultySlot}' and item_id='${objectToDrop.faultyItem}' `);
            
            }
       }

      DroppedInventories[NewDroppedName] = { position: { x: coords[0], y: coords[1], z: coords[2] }, name: NewDroppedName, used: false, lastUpdated: Date.now() }
      emitNet("Inventory-Dropped-Addition", -1, DroppedInventories[NewDroppedName] )
    } else if(secondInventory == "2") {
        var targetinvname = targetName;
        var shopArray = ConvenienceStore();
        var shopAmount = 6;
        emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
    }
    else if(secondInventory == "4")
{
    var targetinvname = targetName;
    var shopArray = HardwareStore();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}
    else if(secondInventory == "5")
    {
        var targetinvname = targetName;
        var shopArray = GunStore();
        var shopAmount = 2;
        emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}
    else if(secondInventory == "6") 
{
    var targetinvname = targetName;
    var shopArray = CraftRiflesStoreGang();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}
    else if(secondInventory == "8")
{
    var targetinvname = targetName;
    var shopArray = CraftRiflesCivilians();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}  
    else if(secondInventory == "9")
{
    var targetinvname = targetName;
    var shopArray = GangStore();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}   
    else if(secondInventory == "10")
{
    var targetinvname = targetName;
    var shopArray = PoliceArmory();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}    
    else if(secondInventory == "12")
{
    var targetinvname = targetName;
    var shopArray = BurgieStore();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}    
   else if(secondInventory == "11")
{
    emitNet("inventory-open-target-NoInject", src, [invArray.arrayCount,playerinvname]);
}  else if(secondInventory == "14") {
    var targetinvname = targetName;
    var shopArray = CourtHouse();
    var shopAmount = 1;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}    
   else if(secondInventory == "15")
{
    var targetinvname = targetName;
    var shopArray = MedicArmory();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}  
   else if(secondInventory == "29")
{
    var targetinvname = targetName;
    var shopArray = MedicArmoryCiv();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}  
   else if(secondInventory == "16")
{
    var targetinvname = targetName;
    var shopArray = Workshop();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}  
   else if(secondInventory == "17")
{
    var targetinvname = targetName;
    var shopArray = Smelting();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}  
   else if(secondInventory == "18")
{
    var targetinvname = targetName;
    var shopArray = TacoTruck();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}  
   else if(secondInventory == "22")
{
    var targetinvname = targetName;
    var shopArray = JailFood();
    var shopAmount = 2;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}  
   else if(secondInventory == "23")
{
    var targetinvname = targetName;
    var shopArray = JailCraft();
    var shopAmount = 1;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}  
   else if(secondInventory == "24")
{
    var targetinvname = targetName;
    var shopArray = JailWeapon();
    var shopAmount = 1;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}  
   else if(secondInventory == "25")
{
    var targetinvname = targetName;
    var shopArray = JailMeth();
    var shopAmount = 1;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}  
   else if(secondInventory == "26")
{
    var targetinvname = targetName;
    var shopArray = JailPhone();
    var shopAmount = 1;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}
   else if(secondInventory == "27")
{
    var targetinvname = targetName;
    var shopArray = JailSlushy();
    var shopAmount = 1;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}
   else if(secondInventory == "28")
{
    var targetinvname = targetName;
    var shopArray = InmateLottery();
    var shopAmount = 7;
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}

// drop an item for a player to pickup
   else if(secondInventory == "7")
{
    var targetinvname = targetName;
    var shopArray = DroppedItem(itemToDropArray);
    
    itemToDropArray = JSON.parse(itemToDropArray)
    var shopAmount = itemToDropArray.length;
     
    emitNet("inventory-open-target", src, [invArray,arrayCount,playerinvname,shopArray,shopAmount,targetinvname,500,false]);
}
else {
    emitNet("inventory-update-player", src, [invArray,arrayCount,playerinvname]);
}
});
});

// checked below 
RegisterServerEvent("server-inventory-close")
onNet("server-inventory-close", async (player, targetInventoryName) => {
    let src = source
    //line 647
    if(targetInventoryName.startsWith("Trunk"))
       emitNet("toggle-animation", src, false);
    InUseInventories = InUseInventories.filter(item => item != player);
    if (targetInventoryName.indexOf("Drop") > -1 && DroppedInventories[targetInventoryName]) {
        if (DroppedInventories[targetInventoryName].used === false ) {
            delete DroppedInventories[targetInventoryName];
        } else {
            let string = `SELECT count(item_id) as amount, item_id, name, information, slot, dropped FROM user_inventory2 WHERE name='${targetInventoryName}' group by item_id, slot `;
            exports.ghmattimysql.execute(string,{}, function(result) {
                if (result.length == 0 && DroppedInventories[targetInventoryName]) {
                    //delete DroppedInventories[targetInventoryName];
                    //emitNet("Inventory-Dropped-Remove", -1, [targetInventoryName])
                }
            });
        }
    }
    emit("server-request-update-src", player, source) 
    sendClientItemList(src)
});


RegisterServerEvent("server-request.removeCraftItems")
onNet("server-inventory.removeCraftItems", async (player, data, coords, openedInv) => {
    // remove items here from crafting
});

let IllegalSearchString = `'weedoz', 'weed5oz', 'coke50g', 'thermite', 'weedq', 'weed12oz', 'oxy', '1gcrack', '1gcocaine', 'joint'`

// checked below

RegisterServerEvent("sniffAccepted")
onNet("sniffAccepted", async (t) => {
    let src = source 
    emitNet('sniffAccepted', t, src)
});


RegisterServerEvent("SniffCID")
onNet("SniffCID", async (cid,src) => {
   
    let name = cid;
    let string = `SELECT count(item_id) as amount, item_id, name, information, slot, dropped FROM user_inventory2 WHERE name='${name}' and item_id IN (${IllegalSearchString}) group by item_id, slot`;

    exports.ghmattimysql.execute(string, {}, function(items) {
        if (item.length > 0) {
            emitNet("k9:SniffConfirmed", src)
        } else {
            emitNet("k9:SniffConfirmedFail", src)
        }
    });
});

// all checked below all correct!
RegisterServerEvent("sniffLicensePlateCheck") 
onNet("sniffLicensePlateCheck", async (plate) => {
     let src = source
     let car = 'Truck-'+plate 
     let glovebox = 'Glovebox-'+plate

     let string = `SELECT count(item_id) as amount, item_id, name, information, slot, dropped FROM user_inventory2 WHERE name='${car}' OR name='${glovebox}') and item_id IN (${IllegalSearchString}) group by item_id, slot`;

     exports.ghmattimysql.execute(string,{}, function(item) {
         if (item.lenth > 0) {
            emitNet("k9:SniffConfirmed", src)
        } else {
            emitNet("k9:SniffConfirmedFail", src)
          }
     });
}); // done an checked 44.45 on stream.

RegisterServerEvent("inv:delete")
onNet("inv:delete", async (inv) => {
    db(`DELECT FROM user_inventory2 WHERE name='${inv}'`);
});

RegisterServerEvent("server-inventory-remove")
onNet("server-inventory-remove-slot", async (player, itemidsent,amount,slot) => {
    var playerinvname = player
    db(`DELETE FROM user_inventory2 WHERE name='${playerinvname}' and item_id='${itemidsent}' and slot='${slot}' LIMIT ${amount}`);
});

RegisterServerEvent("server-ragdoll-items") 
onNet("server-ragdoll-items", async (player) => {
    let currInventoryName = `${player}`
    let newInventoryName = `wait-${player}`
    db(`UPDATE user_inventory2 SET name='${newInventoryName}', WHERE name='${currInventoryName}' and dropped=0 and item_id="mobilephone" `);
    db(`UPDATE user_inventory2 SET name='${newInventoryName}', WHERE name='${currInventoryName}' and dropped=0 and item_id="idcard" `);

    await db(`DELETE FROM user_inventory2 WHERE name='${currInventoryName}'`);

    db(`UPDATE user_inventory2 SET name='${currInventoryName}', WHERE name='${newInventoryName}' and dropped=0`);
});

RegisterServerEvent('server-jail-item')
onNet("server-jail-item", async (player,isSentToJail) => {
    let currInventoryName = `${player}`
    let newInventoryName = `${player}`

    if(!isSentToJail) {
        currInventoryName = `${player}`
        newInventoryName = `jail-${player}`
    } else {
        currInventoryName = `jail-${player}`
        newInventoryName = `${player}`
    }

    db(`UPDATE user_inventory2 SET name='${currInventoryName}', WHERE name='${newInventoryName}' anfd dropped=0`);
});

function removecash(src,amount) {
    emit('inentory:removecash',src,amount)
}

function payStore(storeName,amount,itemid) {

   if (storeName.indexOf("Traphouse") > -1 ) {
       let id = storeName.split('|')

       id = id[0].split('-')[1]

       emit('traps:pay',id,amount)
   } else {
       
       let cid = storeName.split('|')
       let name = cid[1]
       if (itemList[itemid].illegal && mathranfdom(1,100) > 80) {
     //      emitNet('IllegalSale',"Store Owner", name)
       }
       cid = cid[0].split('-')[1]
       emit('server:PayStoreOwner', cid, amount)
   }
}//

RegisterServerEvent("server-inventory-move")
onNet("server-inventory-move", async (player, data, coords) => {
    let targetslot = data[0]
    let startslot = data[1]
    let targetname = data[2].replace(/"/g, "");
    let startname = data[3].replace(/"/g, "");
    let purchase = data[4]
    let itemCosts = data[5]
    let itemidsent = data[6]
    let amount = data[7]
    let crafting = data[8]
    let isWeapon = data[9]
    let PlayerStore = data[10]
    let creationDate = Date.now()

    if ((targetname.indexOf("Drop") > -1 || targetname.indexOf("hidden") > -1) && DroppedInventories[targetname]) {

        if (DroppedInventories[targetname].used === false) {

            DroppedInventories[targetname] = { position: { x: coords[0], y: coords[1], z: coords[2]}, name: targetname, used: true, lastUpdated: Date.now() }
            emitNet("Inventory-Dropped-Addition", -1, DroppedInventories[targetname] )
        }
    }

    let info = "{}"

    if (purchase) {
        info = await GenerateInformation(player,itemidsent)
        removecash(source,itemCosts)
        emit("inventory:takeMyCash", source,itemCosts)
        if (!PlayerStore) {
            for (let i = 0; i < parseInt(amount); i++) {
                db(`INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES ('${itemidsent}','${targetname}','${info}','${targetslot}','${creationDate}' );`);
            }
        } else if (PlayerStore) { // ! at the start 
            for (let i = 0; i < parseInt(amount); i++) {
                db(`UPDATE user_inventory2 SET slot='${targetslot}', name='${targetname}', dropped='0' WHERE slot='${startslot}' and name='${startname}'`);
            }
        } else {
            if (targetname.indexOf("Drop") > -1 || targetname.indexOf("hidden") > -1) {
            db(`INSERT INTO user_inventory2 SET slot='${targetslot}', name='${targetname}', dropped='1' WHERE slot='${startslot}' AND name='${startname}'`);
           } else {
            db(`UPDATE user_inventory2 SET slot='${targetslot}', name='${targetname}', dropped='0' WHERE slot='${startslot}' and name='${startname}'`);

           }
        }
    } else if (crafting) {
        info - await GenerateInformation(player,itemidsent)
        for (let i = 0; i < parseInt(amount); i++) {
            db(`INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES ('${itemidsent}','${targetname}','${info}','${targetslot}','${creationDate}' );`);
        }
    } else {
        db(`UPDATE user_inventory2 SET slot='${targetslot}', name='${targetname}', dropped='0' WHERE slot='${startslot}' and name='${startname}'`);
    }
});

RegisterServerEvent("server-inventory-stack")
onNet("server-inventory-stack", async (player, data, coords) => {
    let targetslot = data[0]
    let moveAmount = data[1]
    let targetname = data[2].replace(/"/g, "");
    let src = source
    let originSlot = data[3]

    let originInventory = data[4].replace(/"/g, "");

    let purchase = data[5]
    let itemCosts = data[6]
    let itemidsent = data[7]
    let amount = data[8]
    let crafting = data[9]
    let isWeapon = data[10]
    let PlayerStore = data[11]
    let amountRemaining = data[12]
    let creationDate = Date.now()

    if ( (targetname.indexOf("Drop") > -1 || targetname.indexOf("hidden") > -1) && DroppedInventories[targetname] ) {
        if (DroppedInventories[targetname].used === false ) {
            DroppedInventories[targetname] =  { position: { x: coords[0], y: coords[1], z: coords[2] }, name: targetname, used: true, lastUpdated: Date.now() }
            emitNet("Inventory-Dropped-Addition", -1, DroppedInventories[targetname] )
        }
    }

    let info = "{}"

    if (purchase) {

        if (isWeapon) {
            hadBrought[player] = true
            emitNet("Inventory-brought-update", -1,JSON.stringify(Object.assign({},hadBrought)))
        }
        info = await GenerateInformation(player,itemidsent)
        removecash(source,itemCosts)

        if (!PlayerStore) {
            for (let i = 0; i < parseInt(amount); i++) {
                db(`INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES ('${itemidsent}','${targetname}','${info}','${targetslot}','${creationDate}' );`);
            }
        }

        if (PlayerStore) {
            let string = `SELECT id FROM user_inventory2 WHERE slot='${originSlot}' AND name='${originInventory}'`; //LIMIT ${moveAmount}
            payStore(originInventory,itemCosts,itemidsent)
            exports.ghmattimysql.execute(string,{}, function(startid) {

                var itemids = "0"
                for (let i = 0; i < startid.length; i++) {
                    itemids = itemids + "," + startid[i].id
                }
                db(`UPDATE user_inventory2 SET slot='${targetslot}', name='${targetname}', dropped='0' WHERE id IN (${itemids})`);
            });
        }

    } else if (crafting) {
        info = await GenerateInformation(player,itemidsent)
        for (let i = 0; i < parseInt(amount); i++) {
            db(`INSERT INTO user_inventory2 (item_id, name, information, slot, creationDate) VALUES ('${itemidsent}','${targetname}','${info}','${targetslot}','${creationDate}' );`);
        }
    } else {
        let string = `SELECT item_id FROM user_inventory2 WHERE slot='${originSlot}' AND name='${originInventory}' LIMIT ${moveAmount}'`;

        exports.ghmattimysql.execute(string,{}, function(startid) {

            var itemids = "0"
            for (let i = 0; i < startid.length; i++) {
                itemids = itemids + "," + startid[i].id
            }

            if (targetname.indexOf("Drop") > -1 || targetname.indexOf("hidden") > -1) {
                db(`UPDATE user_inventory2 SET slot='${targetslot}', name='${targetname}', dropped='1' WHERE id IN (${itemids})`);
            } else {
                db(`UPDATE user_inventory2 SET slot='${targetslot}', name='${targetname}', dropped='0' WHERE id IN (${itemids})`);
            }
        });
    }
});


RegisterServerEvent("server-inventory-swap")
onNet("server-inventory-swap", (player, data, coords) => {

    let targetslot = data[0]
    let targetname = data[1].replace(/"/g, "");
    let startslot = data[2]
    let startname = data[3].replace(/"/g, "");

    let string = `SELECT item_id, id FROM user_inventory2 WHERE slot='${targetslot}' AND name='${targetname}'`;

    exports.ghmattimysql.execute(string,{}, function(startid) {

        var itemidsent = "0"
        for (let i = 0; i < startid.length; i++) {
            itemidsent = itemidsent + "," + startid[i].id
        }

        let string = false

        if (targetname.indexOf("Drop") > -1 || targetname.indexOf("hidden") > -1) {
            string = `UPDATE user_inventory2 SET slot='${targetslot}', name='${targetname}', dropped='1' WHERE slot='${startslot}' AND name='${startname}'`;
        } else {
            string = `UPDATE user_inventory2 SET slot='${targetslot}', name='${targetname}', dropped='0' WHERE slot='${startslot}' AND name='${startname}'`;
        }

        exports.ghmattimysql.execute(string,{}, function(inventory) {
            if (startname.indexOf("Drop") > -1 || startname.indexOf("hidden") > -1) {
                db(`UPDATE user_inventory2 SET slot='${startslot}', name='${startname}', dropped='1' WHERE id IN (${itemidsent})`);
            } else {
                db(`UPDATE user_inventory2 SET slot='${startslot}', name='${startname}', dropped='0' WHERE id IN (${itemidsent})`);
            }
        });
    });
});

onNet('onResourceStart', (resource) => {
    if (resource == GetCurrentResourceName()){
        db(`DELETE FROM user_inventory2 WHERE name like '%Drop%' OR name like '%trash%'`)
    }
})