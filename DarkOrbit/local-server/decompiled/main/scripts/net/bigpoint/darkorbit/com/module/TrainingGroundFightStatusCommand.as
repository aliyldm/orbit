package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TrainingGroundFightStatusCommand extends TrainingGroundStatusDataModule
   {
      
      private static var _instance:TrainingGroundFightStatusCommand;
      
      public var seasonName:String = "";
      
      public var opponentInstanceId:int = 0;
      
      public var opponentUid:int = 0;
      
      public var opponentName:String = "";
      
      public var fightInfo:TrainingGroundFightInfoCommand;
      
      public var roundInfo:TrainingGroundRoundInfoCommand;
      
      public function TrainingGroundFightStatusCommand(param1:String = "", param2:String = "", param3:int = 0, param4:int = 0, param5:TrainingGroundFightInfoCommand = null, param6:TrainingGroundRoundInfoCommand = null)
      {
         super();
         this.seasonName = param1;
         this.opponentInstanceId = param4;
         this.opponentUid = param3;
         this.opponentName = param2;
         if(param5 == null)
         {
            this.fightInfo = new TrainingGroundFightInfoCommand();
         }
         else
         {
            this.fightInfo = param5;
         }
         if(param6 == null)
         {
            this.roundInfo = new TrainingGroundRoundInfoCommand();
         }
         else
         {
            this.roundInfo = param6;
         }
      }
      
      public static function get instance() : TrainingGroundFightStatusCommand
      {
         return _instance || (_instance = new TrainingGroundFightStatusCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -25252;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.seasonName = param1.readUTF();
         this.opponentInstanceId = param1.readInt();
         this.opponentInstanceId = this.opponentInstanceId << 11 % 32 | this.opponentInstanceId >>> 32 - 11 % 32;
         this.opponentUid = param1.readInt();
         this.opponentUid = this.opponentUid << 2 % 32 | this.opponentUid >>> 32 - 2 % 32;
         this.opponentName = param1.readUTF();
         this.fightInfo = TrainingGroundFightInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.fightInfo)
         {
            this.fightInfo.read(param1);
         }
         this.roundInfo = TrainingGroundRoundInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.roundInfo)
         {
            this.roundInfo.read(param1);
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-25252);
         super.write(param1);
         param1.writeUTF(this.seasonName);
         param1.writeInt(this.opponentInstanceId >>> 11 % 32 | this.opponentInstanceId << 32 - 11 % 32);
         param1.writeInt(this.opponentUid >>> 2 % 32 | this.opponentUid << 32 - 2 % 32);
         param1.writeUTF(this.opponentName);
         if(null != this.fightInfo)
         {
            this.fightInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.roundInfo)
         {
            this.roundInfo.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

