package net.bigpoint.darkorbit.com.module.porting.clan
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ChangeClanDescriptionRequest implements IModule
   {
      
      private static var _instance:ChangeClanDescriptionRequest;
      
      public var desc:String = "";
      
      public function ChangeClanDescriptionRequest(param1:String = "")
      {
         super();
         this.desc = param1;
      }
      
      public static function get instance() : ChangeClanDescriptionRequest
      {
         return _instance || (_instance = new ChangeClanDescriptionRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -25809;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.desc = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-25809);
         param1.writeUTF(this.desc);
      }
   }
}

