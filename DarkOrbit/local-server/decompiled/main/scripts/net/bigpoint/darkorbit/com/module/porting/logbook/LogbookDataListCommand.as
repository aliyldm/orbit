package net.bigpoint.darkorbit.com.module.porting.logbook
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class LogbookDataListCommand implements IModule
   {
      
      private static var _instance:LogbookDataListCommand;
      
      public var startIndex:int = 0;
      
      public var total:Number = 0;
      
      public var list:Vector.<LogbookDataCommand>;
      
      public function LogbookDataListCommand(param1:int = 0, param2:Number = 0, param3:Vector.<LogbookDataCommand> = null)
      {
         super();
         this.startIndex = param1;
         this.total = param2;
         if(param3 == null)
         {
            this.list = new Vector.<LogbookDataCommand>();
         }
         else
         {
            this.list = param3;
         }
      }
      
      public static function get instance() : LogbookDataListCommand
      {
         return _instance || (_instance = new LogbookDataListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17891;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:LogbookDataCommand = null;
         this.startIndex = param1.readInt();
         this.startIndex = this.startIndex >>> 13 % 32 | this.startIndex << 32 - 13 % 32;
         this.total = param1.readDouble();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.list.length > 0)
         {
            this.list.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = LogbookDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.list.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:LogbookDataCommand = null;
         param1.writeShort(17891);
         param1.writeInt(this.startIndex << 13 % 32 | this.startIndex >>> 32 - 13 % 32);
         param1.writeDouble(this.total);
         param1.writeByte(this.list.length);
         for each(_loc2_ in this.list)
         {
            _loc2_.write(param1);
         }
      }
   }
}

