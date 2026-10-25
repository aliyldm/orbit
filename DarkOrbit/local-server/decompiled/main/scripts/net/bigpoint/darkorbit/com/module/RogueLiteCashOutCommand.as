package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteCashOutCommand implements IModule
   {
      
      private static var _instance:RogueLiteCashOutCommand;
      
      public var confirmedList:Vector.<InventoryItemModule>;
      
      public var chanceUpList:Vector.<InventoryItemModule>;
      
      public function RogueLiteCashOutCommand(param1:Vector.<InventoryItemModule> = null, param2:Vector.<InventoryItemModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.confirmedList = new Vector.<InventoryItemModule>();
         }
         else
         {
            this.confirmedList = param1;
         }
         if(param2 == null)
         {
            this.chanceUpList = new Vector.<InventoryItemModule>();
         }
         else
         {
            this.chanceUpList = param2;
         }
      }
      
      public static function get instance() : RogueLiteCashOutCommand
      {
         return _instance || (_instance = new RogueLiteCashOutCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -22050;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:InventoryItemModule = null;
         var _loc5_:InventoryItemModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.confirmedList.length > 0)
         {
            this.confirmedList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = InventoryItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.confirmedList.push(_loc4_);
            _loc2_++;
         }
         while(this.chanceUpList.length > 0)
         {
            this.chanceUpList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = InventoryItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.chanceUpList.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:InventoryItemModule = null;
         var _loc3_:InventoryItemModule = null;
         param1.writeShort(-22050);
         param1.writeByte(this.confirmedList.length);
         for each(_loc2_ in this.confirmedList)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.chanceUpList.length);
         for each(_loc3_ in this.chanceUpList)
         {
            _loc3_.write(param1);
         }
      }
   }
}

