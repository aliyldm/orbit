package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class PlutusScoreEntryModule implements IModule
   {
      
      private static var _instance:PlutusScoreEntryModule;
      
      public var score:int = 0;
      
      public var timeInSeconds:int = 0;
      
      public function PlutusScoreEntryModule(param1:int = 0, param2:int = 0)
      {
         super();
         this.score = param1;
         this.timeInSeconds = param2;
      }
      
      public static function get instance() : PlutusScoreEntryModule
      {
         return _instance || (_instance = new PlutusScoreEntryModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 26875;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.score = param1.readInt();
         this.score = this.score >>> 10 % 32 | this.score << 32 - 10 % 32;
         this.timeInSeconds = param1.readInt();
         this.timeInSeconds = this.timeInSeconds << 4 % 32 | this.timeInSeconds >>> 32 - 4 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(26875);
         param1.writeInt(this.score << 10 % 32 | this.score >>> 32 - 10 % 32);
         param1.writeInt(this.timeInSeconds >>> 4 % 32 | this.timeInSeconds << 32 - 4 % 32);
      }
   }
}

