package net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model
{
   import flash.events.EventDispatcher;
   import net.bigpoint.darkorbit.com.module.InventoryItemModule;
   import net.bigpoint.darkorbit.com.module.RogueLiteDroneModule;
   import net.bigpoint.darkorbit.com.module.RogueLiteSelectShipCommand;
   import net.bigpoint.darkorbit.com.module.RogueLiteShipModule;
   import net.bigpoint.darkorbit.delete_in_eic.ItemVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteDroneVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLitePetEquipmentVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteShipEquipmentVO;
   import net.bigpoint.darkorbit.mvc.gui.windows.roguelite.model.vo.RogueLiteShipVO;
   import org.osflash.signals.ISignal;
   import org.osflash.signals.Signal;
   
   public class RogueLiteSelectionUIData extends EventDispatcher
   {
      
      public var loadoutChoiceChanged:ISignal = new Signal();
      
      private var _shipSelectionData:Vector.<RogueLiteShipVO> = new Vector.<RogueLiteShipVO>(0);
      
      private var _selectedLoadoutId:String;
      
      public function RogueLiteSelectionUIData()
      {
         super();
      }
      
      public function set selectedLoadoutId(param1:String) : void
      {
         this._selectedLoadoutId = param1;
      }
      
      public function get selectedLoadoutId() : String
      {
         return this._selectedLoadoutId;
      }
      
      public function updateShipList(param1:RogueLiteSelectShipCommand) : void
      {
         var _loc4_:RogueLiteShipModule = null;
         var _loc5_:RogueLiteShipEquipmentVO = null;
         var _loc6_:InventoryItemModule = null;
         var _loc7_:int = 0;
         var _loc8_:RogueLitePetEquipmentVO = null;
         var _loc9_:Vector.<RogueLiteDroneVO> = null;
         var _loc10_:RogueLiteShipVO = null;
         var _loc11_:RogueLiteDroneModule = null;
         var _loc12_:RogueLiteDroneVO = null;
         var _loc13_:InventoryItemModule = null;
         var _loc14_:InventoryItemModule = null;
         this._shipSelectionData = new Vector.<RogueLiteShipVO>(0);
         var _loc2_:int = int(param1.shipList.length);
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_)
         {
            _loc4_ = param1.shipList[_loc3_];
            _loc5_ = new RogueLiteShipEquipmentVO();
            _loc7_ = 0;
            while(_loc7_ < _loc4_.equipments.length)
            {
               _loc6_ = _loc4_.equipments[_loc7_];
               _loc5_.addItem(_loc6_);
               _loc7_++;
            }
            _loc8_ = new RogueLitePetEquipmentVO();
            _loc7_ = 0;
            while(_loc7_ < _loc4_.petEquipments.length)
            {
               _loc6_ = _loc4_.petEquipments[_loc7_];
               _loc8_.addItem(_loc6_);
               _loc7_++;
            }
            _loc9_ = new Vector.<RogueLiteDroneVO>(0);
            _loc7_ = 0;
            while(_loc7_ < _loc4_.drones.length)
            {
               _loc11_ = _loc4_.drones[_loc7_];
               _loc12_ = new RogueLiteDroneVO(_loc11_.lootId,_loc11_.level);
               if(_loc11_.equipments.length > 1)
               {
                  _loc13_ = _loc11_.equipments[0];
                  _loc12_.equip1 = ItemVO.fromModule(_loc13_);
                  _loc14_ = _loc11_.equipments[1];
                  _loc12_.equip2 = ItemVO.fromModule(_loc14_);
               }
               _loc9_.push(_loc12_);
               _loc7_++;
            }
            _loc10_ = new RogueLiteShipVO(_loc4_.loadOutId,_loc4_.lootId,_loc4_.hp,_loc4_.shield,_loc4_.spread,_loc4_.speed,_loc5_,"pet_pet10",_loc8_,_loc9_);
            this._shipSelectionData.push(_loc10_);
            _loc3_++;
         }
         this.loadoutChoiceChanged.dispatch();
      }
      
      public function get shipSelectionData() : Vector.<RogueLiteShipVO>
      {
         return this._shipSelectionData;
      }
   }
}

