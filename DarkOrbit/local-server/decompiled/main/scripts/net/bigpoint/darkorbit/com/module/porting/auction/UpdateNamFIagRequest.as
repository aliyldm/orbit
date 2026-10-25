package net.bigpoint.darkorbit.com.module.porting.auction
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class UpdateNamFIagRequest implements IModule
   {
      
      private static var _instance:UpdateNamFIagRequest;
      
      public var open:Boolean = false;
      
      public function UpdateNamFIagRequest(param1:Boolean = false)
      {
         super();
         this.open = param1;
      }
      
      public static function get instance() : UpdateNamFIagRequest
      {
         return _instance || (_instance = new UpdateNamFIagRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3583;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.open = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3583);
         param1.writeBoolean(this.open);
      }
   }
}

