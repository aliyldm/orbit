package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TrainingGroundPlayerCombatStatusInfoCommand implements IModule
   {
      
      private static var _instance:TrainingGroundPlayerCombatStatusInfoCommand;
      
      public var inCombat:Boolean = false;
      
      public function TrainingGroundPlayerCombatStatusInfoCommand(param1:Boolean = false)
      {
         super();
         this.inCombat = param1;
      }
      
      public static function get instance() : TrainingGroundPlayerCombatStatusInfoCommand
      {
         return _instance || (_instance = new TrainingGroundPlayerCombatStatusInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7356;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 1;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.inCombat = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-7356);
         param1.writeBoolean(this.inCombat);
      }
   }
}

