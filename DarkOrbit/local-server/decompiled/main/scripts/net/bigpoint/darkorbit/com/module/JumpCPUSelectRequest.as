package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class JumpCPUSelectRequest implements IModule
   {
      
      private static var _instance:JumpCPUSelectRequest;
      
      public var mapId:int = 0;
      
      public function JumpCPUSelectRequest(param1:int = 0)
      {
         super();
         this.mapId = param1;
      }
      
      public static function get instance() : JumpCPUSelectRequest
      {
         return _instance || (_instance = new JumpCPUSelectRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 37;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mapId = param1.readInt();
         this.mapId = this.mapId << 4 % 32 | this.mapId >>> 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(37);
         param1.writeInt(this.mapId >>> 4 % 32 | this.mapId << 32 - 4 % 32);
      }
   }
}

