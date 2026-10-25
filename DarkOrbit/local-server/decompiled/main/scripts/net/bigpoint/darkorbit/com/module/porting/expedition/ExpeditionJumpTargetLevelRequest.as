package net.bigpoint.darkorbit.com.module.porting.expedition
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class ExpeditionJumpTargetLevelRequest implements IModule
   {
      
      private static var _instance:ExpeditionJumpTargetLevelRequest;
      
      public var jumpTargetLevel:int = 0;
      
      public function ExpeditionJumpTargetLevelRequest(param1:int = 0)
      {
         super();
         this.jumpTargetLevel = param1;
      }
      
      public static function get instance() : ExpeditionJumpTargetLevelRequest
      {
         return _instance || (_instance = new ExpeditionJumpTargetLevelRequest());
      }
      
      public function getLibcomModuleId() : int
      {
         return -19463;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 4;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.jumpTargetLevel = param1.readInt();
         this.jumpTargetLevel = this.jumpTargetLevel << 14 % 32 | this.jumpTargetLevel >>> 32 - 14 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-19463);
         param1.writeInt(this.jumpTargetLevel >>> 14 % 32 | this.jumpTargetLevel << 32 - 14 % 32);
      }
   }
}

