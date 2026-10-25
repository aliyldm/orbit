package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PerformanceTrackingSendInfoRequest implements IModule
   {
      
      private static var _instance:PerformanceTrackingSendInfoRequest;
      
      public var version:String = "";
      
      public var fps:int = 0;
      
      public var memoryUsage:int = 0;
      
      public var optionalPerformanceValues:Vector.<int>;
      
      public function PerformanceTrackingSendInfoRequest(param1:String = "", param2:int = 0, param3:int = 0, param4:Vector.<int> = null)
      {
         super();
         this.version = param1;
         this.fps = param2;
         this.memoryUsage = param3;
         if(param4 == null)
         {
            this.optionalPerformanceValues = new Vector.<int>();
         }
         else
         {
            this.optionalPerformanceValues = param4;
         }
      }
      
      public static function get instance() : PerformanceTrackingSendInfoRequest
      {
         return _instance || (_instance = new PerformanceTrackingSendInfoRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 150;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 14;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         this.version = param1.readUTF();
         this.fps = param1.readInt();
         this.fps = this.fps >>> 1 % 32 | this.fps << 32 - 1 % 32;
         this.memoryUsage = param1.readInt();
         this.memoryUsage = this.memoryUsage >>> 13 % 32 | this.memoryUsage << 32 - 13 % 32;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.optionalPerformanceValues.length > 0)
         {
            this.optionalPerformanceValues.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ << 11 % 32 | _loc4_ >>> 32 - 11 % 32;
            this.optionalPerformanceValues.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         param1.writeShort(150);
         param1.writeUTF(this.version);
         param1.writeInt(this.fps << 1 % 32 | this.fps >>> 32 - 1 % 32);
         param1.writeInt(this.memoryUsage << 13 % 32 | this.memoryUsage >>> 32 - 13 % 32);
         param1.writeByte(this.optionalPerformanceValues.length);
         for each(_loc2_ in this.optionalPerformanceValues)
         {
            param1.writeInt(_loc2_ >>> 11 % 32 | _loc2_ << 32 - 11 % 32);
         }
      }
   }
}

