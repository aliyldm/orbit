package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class HuntInfoCommand implements IModule
   {
      
      private static var _instance:HuntInfoCommand;
      
      public var timeLeft:Number = 0;
      
      public var totalClanPoints:int = 0;
      
      public var playerPoints:int = 0;
      
      public var filename:String = "";
      
      public var playerRanges:Vector.<RankRewardRangeModule>;
      
      public var clanRanges:Vector.<RankRewardRangeModule>;
      
      public function HuntInfoCommand(param1:Number = 0, param2:int = 0, param3:int = 0, param4:String = "", param5:Vector.<RankRewardRangeModule> = null, param6:Vector.<RankRewardRangeModule> = null)
      {
         super();
         this.timeLeft = param1;
         this.totalClanPoints = param3;
         this.playerPoints = param2;
         this.filename = param4;
         if(param5 == null)
         {
            this.playerRanges = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.playerRanges = param5;
         }
         if(param6 == null)
         {
            this.clanRanges = new Vector.<RankRewardRangeModule>();
         }
         else
         {
            this.clanRanges = param6;
         }
      }
      
      public static function get instance() : HuntInfoCommand
      {
         return _instance || (_instance = new HuntInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -29644;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 26;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RankRewardRangeModule = null;
         var _loc5_:RankRewardRangeModule = null;
         this.timeLeft = param1.readDouble();
         this.totalClanPoints = param1.readInt();
         this.totalClanPoints = this.totalClanPoints << 1 % 32 | this.totalClanPoints >>> 32 - 1 % 32;
         this.playerPoints = param1.readInt();
         this.playerPoints = this.playerPoints << 1 % 32 | this.playerPoints >>> 32 - 1 % 32;
         this.filename = param1.readUTF();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.playerRanges.length > 0)
         {
            this.playerRanges.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.playerRanges.push(_loc4_);
            _loc2_++;
         }
         while(this.clanRanges.length > 0)
         {
            this.clanRanges.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = RankRewardRangeModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.clanRanges.push(_loc5_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RankRewardRangeModule = null;
         var _loc3_:RankRewardRangeModule = null;
         param1.writeShort(-29644);
         param1.writeDouble(this.timeLeft);
         param1.writeInt(this.totalClanPoints >>> 1 % 32 | this.totalClanPoints << 32 - 1 % 32);
         param1.writeInt(this.playerPoints >>> 1 % 32 | this.playerPoints << 32 - 1 % 32);
         param1.writeUTF(this.filename);
         param1.writeByte(this.playerRanges.length);
         for each(_loc2_ in this.playerRanges)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.clanRanges.length);
         for each(_loc3_ in this.clanRanges)
         {
            _loc3_.write(param1);
         }
      }
   }
}

