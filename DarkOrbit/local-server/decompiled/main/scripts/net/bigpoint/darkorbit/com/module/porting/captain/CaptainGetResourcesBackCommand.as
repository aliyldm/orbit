package net.bigpoint.darkorbit.com.module.porting.captain
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class CaptainGetResourcesBackCommand implements IModule
   {
      
      private static var _instance:CaptainGetResourcesBackCommand;
      
      public var amount:Number = 0;
      
      public var lootId:String = "";
      
      public function CaptainGetResourcesBackCommand(param1:String = "", param2:Number = 0)
      {
         super();
         this.amount = param2;
         this.lootId = param1;
      }
      
      public static function get instance() : CaptainGetResourcesBackCommand
      {
         return _instance || (_instance = new CaptainGetResourcesBackCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -13532;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 10;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.amount = param1.readDouble();
         this.lootId = param1.readUTF();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-13532);
         param1.writeDouble(this.amount);
         param1.writeUTF(this.lootId);
      }
   }
}

