package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ChangeClanTaxRequest implements IModule
   {
      
      private static var _instance:ChangeClanTaxRequest;
      
      public var tax:int = 0;
      
      public function ChangeClanTaxRequest(param1:int = 0)
      {
         super();
         this.tax = param1;
      }
      
      public static function get instance() : ChangeClanTaxRequest
      {
         return _instance || (_instance = new ChangeClanTaxRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 23774;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.tax = param1.readInt();
         this.tax = this.tax >>> 14 % 32 | this.tax << 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(23774);
         param1.writeInt(this.tax << 14 % 32 | this.tax >>> 32 - 14 % 32);
      }
   }
}

