package net.bigpoint.darkorbit.com.module.porting.hangar
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class HangarShipsCommand implements IModule
   {
      
      private static var _instance:HangarShipsCommand;
      
      public var ships:Vector.<HangarShipBriefCommand>;
      
      public var items:Vector.<InventoryItemPack>;
      
      public var allDesignPack:Vector.<ShipDesignPack>;
      
      public var petView:HangarShipPetView;
      
      public var drones:Vector.<HangarShipDroneView>;
      
      public function HangarShipsCommand(param1:Vector.<HangarShipBriefCommand> = null, param2:HangarShipPetView = null, param3:Vector.<HangarShipDroneView> = null, param4:Vector.<ShipDesignPack> = null, param5:Vector.<InventoryItemPack> = null)
      {
         super();
         if(param1 == null)
         {
            this.ships = new Vector.<HangarShipBriefCommand>();
         }
         else
         {
            this.ships = param1;
         }
         if(param5 == null)
         {
            this.items = new Vector.<InventoryItemPack>();
         }
         else
         {
            this.items = param5;
         }
         if(param4 == null)
         {
            this.allDesignPack = new Vector.<ShipDesignPack>();
         }
         else
         {
            this.allDesignPack = param4;
         }
         if(param2 == null)
         {
            this.petView = new HangarShipPetView();
         }
         else
         {
            this.petView = param2;
         }
         if(param3 == null)
         {
            this.drones = new Vector.<HangarShipDroneView>();
         }
         else
         {
            this.drones = param3;
         }
      }
      
      public static function get instance() : HangarShipsCommand
      {
         return _instance || (_instance = new HangarShipsCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 6855;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:HangarShipBriefCommand = null;
         var _loc5_:InventoryItemPack = null;
         var _loc6_:ShipDesignPack = null;
         var _loc7_:HangarShipDroneView = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.ships.length > 0)
         {
            this.ships.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = HangarShipBriefCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.ships.push(_loc4_);
            _loc2_++;
         }
         while(this.items.length > 0)
         {
            this.items.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = InventoryItemPack(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.items.push(_loc5_);
            _loc2_++;
         }
         while(this.allDesignPack.length > 0)
         {
            this.allDesignPack.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = ShipDesignPack(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.allDesignPack.push(_loc6_);
            _loc2_++;
         }
         this.petView = HangarShipPetView(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.petView)
         {
            this.petView.read(param1);
         }
         while(this.drones.length > 0)
         {
            this.drones.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc7_ = HangarShipDroneView(ModuleFactory.get().createInstance(param1.readShort()));
            _loc7_.read(param1);
            this.drones.push(_loc7_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:HangarShipBriefCommand = null;
         var _loc3_:InventoryItemPack = null;
         var _loc4_:ShipDesignPack = null;
         var _loc5_:HangarShipDroneView = null;
         param1.writeShort(6855);
         param1.writeByte(this.ships.length);
         for each(_loc2_ in this.ships)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.items.length);
         for each(_loc3_ in this.items)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.allDesignPack.length);
         for each(_loc4_ in this.allDesignPack)
         {
            _loc4_.write(param1);
         }
         if(null != this.petView)
         {
            this.petView.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.drones.length);
         for each(_loc5_ in this.drones)
         {
            _loc5_.write(param1);
         }
      }
   }
}

