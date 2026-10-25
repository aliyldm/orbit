package net.bigpoint.darkorbit.com.module.porting.logbook
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class LogbookDataListRequest implements IModule
   {
      
      private static var _instance:LogbookDataListRequest;
      
      public var startIndex:int = 0;
      
      public function LogbookDataListRequest(param1:int = 0)
      {
         super();
         this.startIndex = param1;
      }
      
      public static function get instance() : LogbookDataListRequest
      {
         return _instance || (_instance = new LogbookDataListRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -23737;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.startIndex = param1.readInt();
         this.startIndex = this.startIndex << 6 % 32 | this.startIndex >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-23737);
         param1.writeInt(this.startIndex >>> 6 % 32 | this.startIndex << 32 - 6 % 32);
      }
   }
}

