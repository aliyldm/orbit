package net.bigpoint.darkorbit.com.module.porting.voyagers
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class VoyagersGateEnterRequest implements IModule
   {
      
      private static var _instance:VoyagersGateEnterRequest;
      
      public var isFree:Boolean = false;
      
      public var instanceLevel:int = 0;
      
      public function VoyagersGateEnterRequest(param1:Boolean = false, param2:int = 0)
      {
         super();
         this.isFree = param1;
         this.instanceLevel = param2;
      }
      
      public static function get instance() : VoyagersGateEnterRequest
      {
         return _instance || (_instance = new VoyagersGateEnterRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 927;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.isFree = param1.readBoolean();
         this.instanceLevel = param1.readInt();
         this.instanceLevel = this.instanceLevel >>> 6 % 32 | this.instanceLevel << 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(927);
         param1.writeBoolean(this.isFree);
         param1.writeInt(this.instanceLevel << 6 % 32 | this.instanceLevel >>> 32 - 6 % 32);
      }
   }
}

