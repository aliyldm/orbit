package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class MemberLoggedOutModule extends PlayerAttributeModule
   {
      
      private static var _instance:MemberLoggedOutModule;
      
      public var loggedOut:Boolean = false;
      
      public function MemberLoggedOutModule(param1:Boolean = false)
      {
         super();
         this.loggedOut = param1;
      }
      
      public static function get instance() : MemberLoggedOutModule
      {
         return _instance || (_instance = new MemberLoggedOutModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -20331;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.loggedOut = param1.readBoolean();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-20331);
         super.write(param1);
         param1.writeBoolean(this.loggedOut);
      }
   }
}

