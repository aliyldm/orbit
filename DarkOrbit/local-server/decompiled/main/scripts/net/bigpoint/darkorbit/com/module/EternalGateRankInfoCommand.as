package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class EternalGateRankInfoCommand implements IModule
   {
      
      private static var _instance:EternalGateRankInfoCommand;
      
      public var myRank:EternalGateRankModule;
      
      public var topRankers:Vector.<EternalGateRankModule>;
      
      public function EternalGateRankInfoCommand(param1:Vector.<EternalGateRankModule> = null, param2:EternalGateRankModule = null)
      {
         super();
         if(param2 == null)
         {
            this.myRank = new EternalGateRankModule();
         }
         else
         {
            this.myRank = param2;
         }
         if(param1 == null)
         {
            this.topRankers = new Vector.<EternalGateRankModule>();
         }
         else
         {
            this.topRankers = param1;
         }
      }
      
      public static function get instance() : EternalGateRankInfoCommand
      {
         return _instance || (_instance = new EternalGateRankInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 2398;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:EternalGateRankModule = null;
         this.myRank = EternalGateRankModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.myRank)
         {
            this.myRank.read(param1);
         }
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
            _loc4_ = EternalGateRankModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.topRankers.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:EternalGateRankModule = null;
         param1.writeShort(2398);
         if(null != this.myRank)
         {
            this.myRank.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         param1.writeByte(this.topRankers.length);
         for each(_loc2_ in this.topRankers)
         {
            _loc2_.write(param1);
         }
      }
   }
}

