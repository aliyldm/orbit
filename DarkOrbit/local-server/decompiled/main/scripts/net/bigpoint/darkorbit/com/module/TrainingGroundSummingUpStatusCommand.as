package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class TrainingGroundSummingUpStatusCommand extends TrainingGroundStatusDataModule
   {
      
      private static var _instance:TrainingGroundSummingUpStatusCommand;
      
      public static const PLAYERMATCHRESULTTYPE_WINNER:int = 0;
      
      public static const PLAYERMATCHRESULTTYPE_LOSER:int = 1;
      
      public static const PLAYERMATCHRESULTTYPE_DRAW:int = 2;
      
      public static const PLAYERMATCHRESULTTYPE__MAX:int = 3;
      
      public var opponentScore:Number = 0;
      
      public var playerWonRounds:int = 0;
      
      public var matchResultType:int = 0;
      
      public var opponentWonRounds:int = 0;
      
      public var playerScore:Number = 0;
      
      public var reward:Vector.<RewardModule>;
      
      public var opponentName:String = "";
      
      public function TrainingGroundSummingUpStatusCommand(param1:int = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:Number = 0, param6:Number = 0, param7:Vector.<RewardModule> = null)
      {
         super();
         this.opponentScore = param6;
         this.playerWonRounds = param2;
         this.matchResultType = param1;
         this.opponentWonRounds = param3;
         this.playerScore = param5;
         if(param7 == null)
         {
            this.reward = new Vector.<RewardModule>();
         }
         else
         {
            this.reward = param7;
         }
         this.opponentName = param4;
      }
      
      public static function get instance() : TrainingGroundSummingUpStatusCommand
      {
         return _instance || (_instance = new TrainingGroundSummingUpStatusCommand());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 12271;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 22;
      }
      
      override public function read(param1:IDataInput) : void
      {
         var _loc4_:RewardModule = null;
         param1.readShort();
         super.read(param1);
         this.opponentScore = param1.readFloat();
         this.playerWonRounds = param1.readInt();
         this.playerWonRounds = this.playerWonRounds << 8 % 32 | this.playerWonRounds >>> 32 - 8 % 32;
         this.matchResultType = param1.readShort();
         this.opponentWonRounds = param1.readInt();
         this.opponentWonRounds = this.opponentWonRounds >>> 12 % 32 | this.opponentWonRounds << 32 - 12 % 32;
         this.playerScore = param1.readFloat();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.reward.length > 0)
         {
            this.reward.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RewardModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.reward.push(_loc4_);
            _loc2_++;
         }
         this.opponentName = param1.readUTF();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         var _loc2_:RewardModule = null;
         param1.writeShort(12271);
         super.write(param1);
         param1.writeFloat(this.opponentScore);
         param1.writeInt(this.playerWonRounds >>> 8 % 32 | this.playerWonRounds << 32 - 8 % 32);
         param1.writeShort(this.matchResultType);
         param1.writeInt(this.opponentWonRounds << 12 % 32 | this.opponentWonRounds >>> 32 - 12 % 32);
         param1.writeFloat(this.playerScore);
         param1.writeByte(this.reward.length);
         for each(_loc2_ in this.reward)
         {
            _loc2_.write(param1);
         }
         param1.writeUTF(this.opponentName);
      }
   }
}

