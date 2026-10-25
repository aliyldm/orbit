package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EventUpdateCommand implements IModule
   {
      
      private static var _instance:EventUpdateCommand;
      
      public var timestamp:Number = 0;
      
      public var activeCommands:Vector.<EventModule>;
      
      public var utcTimeOffset:int = 0;
      
      public function EventUpdateCommand(param1:Vector.<EventModule> = null, param2:Number = 0, param3:int = 0)
      {
         super();
         this.timestamp = param2;
         if(param1 == null)
         {
            this.activeCommands = new Vector.<EventModule>();
         }
         else
         {
            this.activeCommands = param1;
         }
         this.utcTimeOffset = param3;
      }
      
      public static function get instance() : EventUpdateCommand
      {
         return _instance || (_instance = new EventUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 31317;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EventModule = null;
         this.timestamp = param1.readDouble();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.activeCommands.length > 0)
         {
            this.activeCommands.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = EventModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.activeCommands.push(_loc4_);
            _loc2_++;
         }
         this.utcTimeOffset = param1.readInt();
         this.utcTimeOffset = this.utcTimeOffset >>> 8 % 32 | this.utcTimeOffset << 32 - 8 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EventModule = null;
         param1.writeShort(31317);
         param1.writeDouble(this.timestamp);
         param1.writeByte(this.activeCommands.length);
         for each(_loc2_ in this.activeCommands)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.utcTimeOffset << 8 % 32 | this.utcTimeOffset >>> 32 - 8 % 32);
      }
   }
}

