package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class FrozenLabyrinthTopRankerInfoCommand implements IModule
   {
      
      private static var _instance:FrozenLabyrinthTopRankerInfoCommand;
      
      public var topRankers:Vector.<FrozenLabyrinthRankModule>;
      
      public function FrozenLabyrinthTopRankerInfoCommand(param1:Vector.<FrozenLabyrinthRankModule> = null)
      {
         super();
         if(param1 == null)
         {
            this.topRankers = new Vector.<FrozenLabyrinthRankModule>();
         }
         else
         {
            this.topRankers = param1;
         }
      }
      
      public static function get instance() : FrozenLabyrinthTopRankerInfoCommand
      {
         return _instance || (_instance = new FrozenLabyrinthTopRankerInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -15999;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:FrozenLabyrinthRankModule = null;
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
            _loc4_ = FrozenLabyrinthRankModule(ModuleFactory.get().createInstance(param1.readShort()));
            _loc4_.read(param1);
            this.topRankers.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:FrozenLabyrinthRankModule = null;
         param1.writeShort(-15999);
         param1.writeByte(this.topRankers.length);
         for each(_loc2_ in this.topRankers)
         {
            _loc2_.write(param1);
         }
      }
   }
}

