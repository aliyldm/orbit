package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalBlacklightSkillPointInfoCommand implements IModule
   {
      
      private static var _instance:EternalBlacklightSkillPointInfoCommand;
      
      public var skillPoint:int = 0;
      
      public function EternalBlacklightSkillPointInfoCommand(param1:int = 0)
      {
         super();
         this.skillPoint = param1;
      }
      
      public static function get instance() : EternalBlacklightSkillPointInfoCommand
      {
         return _instance || (_instance = new EternalBlacklightSkillPointInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -10680;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.skillPoint = param1.readInt();
         this.skillPoint = this.skillPoint << 5 % 32 | this.skillPoint >>> 32 - 5 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-10680);
         param1.writeInt(this.skillPoint >>> 5 % 32 | this.skillPoint << 32 - 5 % 32);
      }
   }
}

