package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RankInfoCommand implements IModule
   {
      
      private static var _instance:RankInfoCommand;
      
      public var topRankers:Vector.<RankModule>;
      
      public var myRank:RankModule;
      
      public function RankInfoCommand(param1:Vector.<RankModule> = null, param2:RankModule = null)
      {
         super();
         if(param1 == null)
         {
            this.topRankers = new Vector.<RankModule>();
         }
         else
         {
            this.topRankers = param1;
         }
         if(param2 == null)
         {
            this.myRank = new RankModule();
         }
         else
         {
            this.myRank = param2;
         }
      }
      
      public static function get instance() : RankInfoCommand
      {
         return _instance || (_instance = new RankInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -12118;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:RankModule = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.topRankers.length > 0)
         {
            this.topRankers.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = RankModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.topRankers.push(_loc4_);
            _loc2_++;
         }
         this.myRank = RankModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.myRank)
         {
            this.myRank.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:RankModule = null;
         param1.writeShort(-12118);
         param1.writeByte(this.topRankers.length);
         for each(_loc2_ in this.topRankers)
         {
            _loc2_.write(param1);
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

