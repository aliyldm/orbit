package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class InvitationBlockModule extends PlayerAttributeModule
   {
      
      private static var _instance:InvitationBlockModule;
      
      public var active:Boolean = false;
      
      public function InvitationBlockModule(param1:Boolean = false)
      {
         super();
         this.active = param1;
      }
      
      public static function get instance() : InvitationBlockModule
      {
         return _instance || (_instance = new InvitationBlockModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -5957;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.active = param1.readBoolean();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-5957);
         super.write(param1);
         param1.writeBoolean(this.active);
      }
   }
}

