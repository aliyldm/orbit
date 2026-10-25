package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class InvitationModeModule implements IModule
   {
      
      private static var _instance:InvitationModeModule;
      
      public static const INVITATIONMODE_BOSS_ONLY:int = 0;
      
      public static const INVITATIONMODE_FREE_FOR_ALL:int = 1;
      
      public static const INVITATIONMODE__MAX:int = 2;
      
      public var mode:int = 0;
      
      public function InvitationModeModule(param1:int = 0)
      {
         super();
         this.mode = param1;
      }
      
      public static function get instance() : InvitationModeModule
      {
         return _instance || (_instance = new InvitationModeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -28295;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.mode = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-28295);
         param1.writeShort(this.mode);
      }
   }
}

