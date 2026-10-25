package net.bigpoint.darkorbit.com.module.porting.halloffame
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   import net.bigpoint.darkorbit.com.module.ModuleFactory;
   
   public class HallOfFameTopDataListCommand implements IModule
   {
      
      private static var _instance:HallOfFameTopDataListCommand;
      
      public var myRankingPoints:HallOfFameRankingPoints;
      
      public var type:int = 0;
      
      public var allRankList:Vector.<HallOfFameDataCommand>;
      
      public var pages:Vector.<HallOfFamePages>;
      
      public var myRankList:Vector.<HallOfFameDataCommand>;
      
      public function HallOfFameTopDataListCommand(param1:int = 0, param2:Vector.<HallOfFameDataCommand> = null, param3:Vector.<HallOfFameDataCommand> = null, param4:HallOfFameRankingPoints = null, param5:Vector.<HallOfFamePages> = null)
      {
         super();
         if(param4 == null)
         {
            this.myRankingPoints = new HallOfFameRankingPoints();
         }
         else
         {
            this.myRankingPoints = param4;
         }
         this.type = param1;
         if(param2 == null)
         {
            this.allRankList = new Vector.<HallOfFameDataCommand>();
         }
         else
         {
            this.allRankList = param2;
         }
         if(param5 == null)
         {
            this.pages = new Vector.<HallOfFamePages>();
         }
         else
         {
            this.pages = param5;
         }
         if(param3 == null)
         {
            this.myRankList = new Vector.<HallOfFameDataCommand>();
         }
         else
         {
            this.myRankList = param3;
         }
      }
      
      public static function get instance() : HallOfFameTopDataListCommand
      {
         return _instance || (_instance = new HallOfFameTopDataListCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -7112;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:HallOfFameDataCommand = null;
         var _loc5_:HallOfFamePages = null;
         var _loc6_:HallOfFameDataCommand = null;
         this.myRankingPoints = HallOfFameRankingPoints(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.myRankingPoints)
         {
            this.myRankingPoints.read(param1);
         }
         this.type = param1.readShort();
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.allRankList.length > 0)
         {
            this.allRankList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = HallOfFameDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.allRankList.push(_loc4_);
            _loc2_++;
         }
         while(this.pages.length > 0)
         {
            this.pages.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc5_ = HallOfFamePages(ModuleFactory.get().createInstance(param1.readShort()));
            _loc5_.read(param1);
            this.pages.push(_loc5_);
            _loc2_++;
         }
         while(this.myRankList.length > 0)
         {
            this.myRankList.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc6_ = HallOfFameDataCommand(ModuleFactory.get().createInstance(param1.readShort()));
            _loc6_.read(param1);
            this.myRankList.push(_loc6_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:HallOfFameDataCommand = null;
         var _loc3_:HallOfFamePages = null;
         var _loc4_:HallOfFameDataCommand = null;
         param1.writeShort(-7112);
         if(null != this.myRankingPoints)
         {
            this.myRankingPoints.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeShort(this.type);
         param1.writeByte(this.allRankList.length);
         for each(_loc2_ in this.allRankList)
         {
            _loc2_.write(param1);
         }
         param1.writeByte(this.pages.length);
         for each(_loc3_ in this.pages)
         {
            _loc3_.write(param1);
         }
         param1.writeByte(this.myRankList.length);
         for each(_loc4_ in this.myRankList)
         {
            _loc4_.write(param1);
         }
      }
   }
}

