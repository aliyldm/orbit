package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class RankRewardRangeModule implements IModule
   {
      
      private static var _instance:RankRewardRangeModule;
      
      public var to:int = 0;
      
      public var from:int = 0;
      
      public function RankRewardRangeModule(param1:int = 0, param2:int = 0)
      {
         super();
         this.to = param2;
         this.from = param1;
      }
      
      public static function get instance() : RankRewardRangeModule
      {
         return _instance || (_instance = new RankRewardRangeModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return -14193;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.to = param1.readInt();
         this.to = this.to >>> 16 % 32 | this.to << 32 - 16 % 32;
         this.from = param1.readInt();
         this.from = this.from << 6 % 32 | this.from >>> 32 - 6 % 32;
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-14193);
         param1.writeInt(this.to << 16 % 32 | this.to >>> 32 - 16 % 32);
         param1.writeInt(this.from >>> 6 % 32 | this.from << 32 - 6 % 32);
      }
   }
}

