package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ReturneeLoginBundleBuyCommand implements IModule
   {
      
      private static var _instance:ReturneeLoginBundleBuyCommand;
      
      public var paymentLink:String = "";
      
      public function ReturneeLoginBundleBuyCommand(param1:String = "")
      {
         super();
         this.paymentLink = param1;
      }
      
      public static function get instance() : ReturneeLoginBundleBuyCommand
      {
         return _instance || (_instance = new ReturneeLoginBundleBuyCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13061;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.paymentLink = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-13061);
         param1.writeUTF(this.paymentLink);
      }
   }
}

