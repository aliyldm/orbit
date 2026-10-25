package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class TitleFrenzyRankingInfoCommand implements IModule
   {
      
      private static var _instance:TitleFrenzyRankingInfoCommand;
      
      public var isActive:Boolean = false;
      
      public var nextRank:TitleFrenzyRankingInfoModule;
      
      public var rankingInfoList:Vector.<TitleFrenzyRankingInfoModule>;
      
      public var prevRank:TitleFrenzyRankingInfoModule;
      
      public var myRank:TitleFrenzyRankingInfoModule;
      
      public function TitleFrenzyRankingInfoCommand(param1:Boolean = false, param2:Vector.<TitleFrenzyRankingInfoModule> = null, param3:TitleFrenzyRankingInfoModule = null, param4:TitleFrenzyRankingInfoModule = null, param5:TitleFrenzyRankingInfoModule = null)
      {
         super();
         this.isActive = param1;
         if(param3 == null)
         {
            this.nextRank = new TitleFrenzyRankingInfoModule();
         }
         else
         {
            this.nextRank = param3;
         }
         if(param2 == null)
         {
            this.rankingInfoList = new Vector.<TitleFrenzyRankingInfoModule>();
         }
         else
         {
            this.rankingInfoList = param2;
         }
         if(param5 == null)
         {
            this.prevRank = new TitleFrenzyRankingInfoModule();
         }
         else
         {
            this.prevRank = param5;
         }
         if(param4 == null)
         {
            this.myRank = new TitleFrenzyRankingInfoModule();
         }
         else
         {
            this.myRank = param4;
         }
      }
      
      public static function get instance() : TitleFrenzyRankingInfoCommand
      {
         return _instance || (_instance = new TitleFrenzyRankingInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15662;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:TitleFrenzyRankingInfoModule = null;
         this.isActive = param1.readBoolean();
         this.nextRank = TitleFrenzyRankingInfoModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.nextRank)
         {
            this.nextRank.read(param1);
         }
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.rankingInfoList.length > 0)
         {
            this.rankingInfoList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = TitleFrenzyRankingInfoModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.rankingInfoList.push(_loc4_);
            _loc2_++;
         }
         this.prevRank = TitleFrenzyRankingInfoModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.prevRank)
         {
            this.prevRank.read(param1);
         }
         this.myRank = TitleFrenzyRankingInfoModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.myRank)
         {
            this.myRank.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:TitleFrenzyRankingInfoModule = null;
         param1.writeShort(-15662);
         param1.writeBoolean(this.isActive);
         if(null != this.nextRank)
         {
            this.nextRank.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.rankingInfoList.length);
         for each(_loc2_ in this.rankingInfoList)
         {
            _loc2_.write(param1);
         }
         if(null != this.prevRank)
         {
            this.prevRank.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.myRank)
         {
            this.myRank.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

