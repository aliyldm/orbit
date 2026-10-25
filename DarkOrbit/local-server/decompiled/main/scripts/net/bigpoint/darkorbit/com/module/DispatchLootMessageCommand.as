package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class DispatchLootMessageCommand implements IModule
   {
      
      private static var _instance:DispatchLootMessageCommand;
      
      public static const MESSAGETYPE_NO_RESOURCE:int = 0;
      
      public static const MESSAGETYPE_COLLECTED:int = 1;
      
      public static const MESSAGETYPE__MAX:int = 2;
      
      public var messageType:int = 0;
      
      public var loots:Vector.<LootModule>;
      
      public function DispatchLootMessageCommand(param1:int = 0, param2:Vector.<LootModule> = null)
      {
         super();
         this.messageType = param1;
         if(param2 == null)
         {
            this.loots = new Vector.<LootModule>();
         }
         else
         {
            this.loots = param2;
         }
      }
      
      public static function get instance() : DispatchLootMessageCommand
      {
         return _instance || (_instance = new DispatchLootMessageCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 13943;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:LootModule = null;
         this.messageType = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.loots.length > 0)
         {
            this.loots.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LootModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.loots.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:LootModule = null;
         param1.writeShort(13943);
         param1.writeShort(this.messageType);
         param1.writeByte(this.loots.length);
         for each(_loc2_ in this.loots)
         {
            _loc2_.write(param1);
         }
      }
   }
}

