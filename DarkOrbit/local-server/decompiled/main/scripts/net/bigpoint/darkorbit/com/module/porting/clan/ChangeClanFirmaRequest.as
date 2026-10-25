package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ChangeClanFirmaRequest implements IModule
   {
      
      private static var _instance:ChangeClanFirmaRequest;
      
      public var firma:int = 0;
      
      public function ChangeClanFirmaRequest(param1:int = 0)
      {
         super();
         this.firma = param1;
      }
      
      public static function get instance() : ChangeClanFirmaRequest
      {
         return _instance || (_instance = new ChangeClanFirmaRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 5985;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.firma = param1.readInt();
         this.firma = this.firma << 9 % 32 | this.firma >>> 32 - 9 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(5985);
         param1.writeInt(this.firma >>> 9 % 32 | this.firma << 32 - 9 % 32);
      }
   }
}

