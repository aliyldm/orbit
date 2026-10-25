package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PayloadEscortInfoCommand implements IModule
   {
      
      private static var _instance:PayloadEscortInfoCommand;
      
      public var timeInfoCommand:PayloadEscortTimeInfoCommand;
      
      public var playerRankRanges:Vector.<RankRewardRangeModule>;
      
      public var totalScore:int = 0;
      
      public var keyInfoCommand:PayloadEscortKeyInfoCommand;
      
      public var isInSession:Boolean = false;
      
      public function PayloadEscortInfoCommand(param1:PayloadEscortTimeInfoCommand = null, param2:PayloadEscortKeyInfoCommand = null, param3:int = 0, param4:Vector.<RankRewardRangeModule> = null, param5:Boolean = false)
      {
         super();
         if(param1 == null)
         {
            this.timeInfoCommand = new PayloadEscortTimeInfoCommand();
         }
         else
         {
            this.timeInfoCommand = param1;
         }
         if(param4 == null)
         {
            this.playerRankRanges = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.playerRankRanges = param4;
         }
         this.totalScore = param3;
         if(param2 == null)
         {
            this.keyInfoCommand = new PayloadEscortKeyInfoCommand();
         }
         else
         {
            this.keyInfoCommand = param2;
         }
         this.isInSession = param5;
      }
      
      public static function get instance() : PayloadEscortInfoCommand
      {
         return _instance || (_instance = new PayloadEscortInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -3264;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 9;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RankRewardRangeModule = null;
         this.timeInfoCommand = PayloadEscortTimeInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.timeInfoCommand)
         {
            this.timeInfoCommand.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.playerRankRanges.length > 0)
         {
            this.playerRankRanges.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.playerRankRanges.push(_loc4_);
            _loc2_++;
         }
         this.totalScore = param1.readInt();
         this.totalScore = this.totalScore << 16 % 32 | this.totalScore >>> 32 - 16 % 32;
         this.keyInfoCommand = PayloadEscortKeyInfoCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.keyInfoCommand)
         {
            this.keyInfoCommand.read(param1);
         }
         this.isInSession = param1.readBoolean();
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         param1.writeShort(-3264);
         if(null != this.timeInfoCommand)
         {
            this.timeInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.playerRankRanges.length);
         for each(_loc2_ in this.playerRankRanges)
         {
            _loc2_.write(param1);
         }
         param1.writeInt(this.totalScore >>> 16 % 32 | this.totalScore << 32 - 16 % 32);
         if(null != this.keyInfoCommand)
         {
            this.keyInfoCommand.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeBoolean(this.isInSession);
      }
   }
}

