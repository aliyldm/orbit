package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteInventoryCommand implements IModule
   {
      
      private static var _instance:RogueLiteInventoryCommand;
      
      public var equipments:Vector.<InventoryItemModule>;
      
      public var inventory:Vector.<InventoryItemModule>;
      
      public var unstableModules:Vector.<UnstableModuleModule>;
      
      public function RogueLiteInventoryCommand(param1:Vector.<InventoryItemModule> = null, param2:Vector.<InventoryItemModule> = null, param3:Vector.<UnstableModuleModule> = null)
      {
         super();
         if(param2 == null)
         {
            this.equipments = new Vector.<InventoryItemModule>();
         }
         else
         {
            this.equipments = param2;
         }
         if(param1 == null)
         {
            this.inventory = new Vector.<InventoryItemModule>();
         }
         else
         {
            this.inventory = param1;
         }
         if(param3 == null)
         {
            this.unstableModules = new Vector.<UnstableModuleModule>();
         }
         else
         {
            this.unstableModules = param3;
         }
      }
      
      public static function get instance() : RogueLiteInventoryCommand
      {
         return _instance || (_instance = new RogueLiteInventoryCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 19867;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:InventoryItemModule = null;
         var _loc5_:InventoryItemModule = null;
         var _loc6_:UnstableModuleModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.equipments.length > 0)
         {
            this.equipments.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = InventoryItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.equipments.push(_loc4_);
            _loc2_++;
         }
         while(this.inventory.length > 0)
         {
            this.inventory.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = InventoryItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.inventory.push(_loc5_);
            _loc2_++;
         }
         while(this.unstableModules.length > 0)
         {
            this.unstableModules.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = UnstableModuleModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.unstableModules.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:InventoryItemModule = null;
         var _loc3_:InventoryItemModule = null;
         var _loc4_:UnstableModuleModule = null;
         param1.writeShort(19867);
         param1.writeByte(this.equipments.length);
         for each(_loc2_ in this.equipments)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.inventory.length);
         for each(_loc3_ in this.inventory)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.unstableModules.length);
         for each(_loc4_ in this.unstableModules)
         {
            _loc4_.write(param1);
         }
      }
   }
}

