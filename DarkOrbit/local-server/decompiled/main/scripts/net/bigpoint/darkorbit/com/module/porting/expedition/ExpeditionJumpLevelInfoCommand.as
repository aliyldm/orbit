package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionJumpLevelInfoCommand implements IModule
   {
      
      private static var _instance:ExpeditionJumpLevelInfoCommand;
      
      public var levels:Vector.<int>;
      
      public var costs:Vector.<int>;
      
      public function ExpeditionJumpLevelInfoCommand(param1:Vector.<int> = null, param2:Vector.<int> = null)
      {
         super();
         if(param1 == null)
         {
            this.levels = new Vector.<int>();
         }
         else
         {
            this.levels = param1;
         }
         if(param2 == null)
         {
            this.costs = new Vector.<int>();
         }
         else
         {
            this.costs = param2;
         }
      }
      
      public static function get instance() : ExpeditionJumpLevelInfoCommand
      {
         return _instance || (_instance = new ExpeditionJumpLevelInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return -3749;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         var _loc4_:int = 0;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         while(this.levels.length > 0)
         {
            this.levels.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 16 % 32 | _loc4_ << 32 - 16 % 32;
            this.levels.push(_loc4_);
            _loc2_++;
         }
         while(this.costs.length > 0)
         {
            this.costs.pop();
         }
         _loc2_ = 0;
         _loc3_ = param1.readByte();
         while(_loc2_ < _loc3_)
         {
            _loc4_ = param1.readInt();
            _loc4_ = _loc4_ >>> 10 % 32 | _loc4_ << 32 - 10 % 32;
            this.costs.push(_loc4_);
            _loc2_++;
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         param1.writeShort(-3749);
         param1.writeByte(this.levels.length);
         for each(_loc2_ in this.levels)
         {
            param1.writeInt(_loc2_ << 16 % 32 | _loc2_ >>> 32 - 16 % 32);
         }
         param1.writeByte(this.costs.length);
         for each(_loc3_ in this.costs)
         {
            param1.writeInt(_loc3_ << 10 % 32 | _loc3_ >>> 32 - 10 % 32);
         }
      }
   }
}

