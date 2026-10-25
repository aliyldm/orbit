package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TrainingGroundConfirmationStatusCommand extends TrainingGroundStatusDataModule
   {
      
      private static var _instance:TrainingGroundConfirmationStatusCommand;
      
      public var timer:int = 0;
      
      public var playerCombatStatusInfo:TrainingGroundPlayerCombatStatusInfoCommand;
      
      public function TrainingGroundConfirmationStatusCommand(param1:int = 0, param2:TrainingGroundPlayerCombatStatusInfoCommand = null)
      {
         super();
         this.timer = param1;
         if(param2 == null)
         {
            this.playerCombatStatusInfo = new TrainingGroundPlayerCombatStatusInfoCommand();
         }
         else
         {
            this.playerCombatStatusInfo = param2;
         }
      }
      
      public static function get instance() : TrainingGroundConfirmationStatusCommand
      {
         return _instance || (_instance = new TrainingGroundConfirmationStatusCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -29891;
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
         this.timer = this.timer >>> 1 % 32 | this.timer << 32 - 1 % 32;
         this.playerCombatStatusInfo = TrainingGroundPlayerCombatStatusInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.playerCombatStatusInfo)
         {
            this.playerCombatStatusInfo.read(param1);
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-29891);
         super.write(param1);
         param1.writeInt(this.timer << 1 % 32 | this.timer >>> 32 - 1 % 32);
         if(null != this.playerCombatStatusInfo)
         {
            this.playerCombatStatusInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

