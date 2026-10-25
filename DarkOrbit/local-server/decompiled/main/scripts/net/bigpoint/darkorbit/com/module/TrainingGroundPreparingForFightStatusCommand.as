package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TrainingGroundPreparingForFightStatusCommand extends TrainingGroundStatusDataModule
   {
      
      private static var _instance:TrainingGroundPreparingForFightStatusCommand;
      
      public var timer:int = 0;
      
      public var opponentCombatStatusInfo:TrainingGroundPlayerCombatStatusInfoCommand;
      
      public function TrainingGroundPreparingForFightStatusCommand(param1:int = 0, param2:TrainingGroundPlayerCombatStatusInfoCommand = null)
      {
         super();
         this.timer = param1;
         if(param2 == null)
         {
            this.opponentCombatStatusInfo = new TrainingGroundPlayerCombatStatusInfoCommand();
         }
         else
         {
            this.opponentCombatStatusInfo = param2;
         }
      }
      
      public static function get instance() : TrainingGroundPreparingForFightStatusCommand
      {
         return _instance || (_instance = new TrainingGroundPreparingForFightStatusCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -19398;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.timer = param1.readInt();
         this.timer = this.timer >>> 5 % 32 | this.timer << 32 - 5 % 32;
         this.opponentCombatStatusInfo = TrainingGroundPlayerCombatStatusInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.opponentCombatStatusInfo)
         {
            this.opponentCombatStatusInfo.read(param1);
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-19398);
         super.write(param1);
         param1.writeInt(this.timer << 5 % 32 | this.timer >>> 32 - 5 % 32);
         if(null != this.opponentCombatStatusInfo)
         {
            this.opponentCombatStatusInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

