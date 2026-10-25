package net.bigpoint.darkorbit.com.module.porting.synthesis
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   import net.bigpoint.darkorbit.com.module.porting.hangar.*;
   
   public class SynthesisInventoryCommand implements IModule
   {
      
      private static var _instance:SynthesisInventoryCommand;
      
      public var equipmentInventoryItems:Vector.<HangarShipEquipmentInventoryItem>;
      
      public var remove:Boolean = false;
      
      public function SynthesisInventoryCommand(param1:Vector.<HangarShipEquipmentInventoryItem> = null, param2:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.equipmentInventoryItems = new Vector.<HangarShipEquipmentInventoryItem>();
         }
         else
         {
            this.equipmentInventoryItems = param1;
         }
         this.remove = param2;
      }
      
      public static function get instance() : SynthesisInventoryCommand
      {
         return _instance || (_instance = new SynthesisInventoryCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 15651;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:HangarShipEquipmentInventoryItem = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.equipmentInventoryItems.length > 0)
         {
            this.equipmentInventoryItems.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readShort();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = HangarShipEquipmentInventoryItem(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.equipmentInventoryItems.push(_loc4_);
            _loc2_++;
         }
         this.remove = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:HangarShipEquipmentInventoryItem = null;
         param1.writeShort(15651);
         param1.writeShort(this.equipmentInventoryItems.length);
         for each(_loc2_ in this.equipmentInventoryItems)
         {
            _loc2_.write(param1);
         }
         param1.writeBoolean(this.remove);
      }
   }
}

