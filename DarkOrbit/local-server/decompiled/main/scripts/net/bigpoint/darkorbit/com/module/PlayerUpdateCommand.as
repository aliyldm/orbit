package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PlayerUpdateCommand implements IModule
   {
      
      private static var _instance:PlayerUpdateCommand;
      
      public var updates:Vector.<PlayerAttributeModule>;
      
      public function PlayerUpdateCommand(param1:Vector.<PlayerAttributeModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.updates = new Vector.<PlayerAttributeModule>();
         }
         else
         {
            this.updates = param1;
         }
      }
      
      public static function get instance() : PlayerUpdateCommand
      {
         return _instance || (_instance = new PlayerUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 12409;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:PlayerAttributeModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.updates.length > 0)
         {
            this.updates.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = PlayerAttributeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.updates.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:PlayerAttributeModule = null;
         param1.writeShort(12409);
         param1.writeByte(this.updates.length);
         for each(_loc2_ in this.updates)
         {
            _loc2_.write(param1);
         }
      }
   }
}

