package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RogueLiteSelectRewardCommand implements IModule
   {
      
      private static var _instance:RogueLiteSelectRewardCommand;
      
      public var content:Vector.<InventoryItemModule>;
      
      public var module:Vector.<UnstableModuleModule>;
      
      public function RogueLiteSelectRewardCommand(param1:Vector.<InventoryItemModule> = null, param2:Vector.<UnstableModuleModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.content = new Vector.<InventoryItemModule>();
         }
         else
         {
            this.content = param1;
         }
         if(param2 == null)
         {
            this.module = new Vector.<UnstableModuleModule>();
         }
         else
         {
            this.module = param2;
         }
      }
      
      public static function get instance() : RogueLiteSelectRewardCommand
      {
         return _instance || (_instance = new RogueLiteSelectRewardCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -18395;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:InventoryItemModule = null;
         var _loc5_:UnstableModuleModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.content.length > 0)
         {
            this.content.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = InventoryItemModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.content.push(_loc4_);
            _loc2_++;
         }
         while(this.module.length > 0)
         {
            this.module.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = UnstableModuleModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.module.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:InventoryItemModule = null;
         var _loc3_:UnstableModuleModule = null;
         param1.writeShort(-18395);
         param1.writeByte(this.content.length);
         for each(_loc2_ in this.content)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.module.length);
         for each(_loc3_ in this.module)
         {
            _loc3_.write(param1);
         }
      }
   }
}

