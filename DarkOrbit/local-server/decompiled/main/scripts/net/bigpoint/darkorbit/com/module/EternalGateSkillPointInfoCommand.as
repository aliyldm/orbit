package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalGateSkillPointInfoCommand implements IModule
   {
      
      private static var _instance:EternalGateSkillPointInfoCommand;
      
      public var skillPoint:int = 0;
      
      public function EternalGateSkillPointInfoCommand(param1:int = 0)
      {
         super();
         this.skillPoint = param1;
      }
      
      public static function get instance() : EternalGateSkillPointInfoCommand
      {
         return _instance || (_instance = new EternalGateSkillPointInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -17944;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.skillPoint = param1.readInt();
         this.skillPoint = this.skillPoint << 15 % 32 | this.skillPoint >>> 32 - 15 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-17944);
         param1.writeInt(this.skillPoint >>> 15 % 32 | this.skillPoint << 32 - 15 % 32);
      }
   }
}

