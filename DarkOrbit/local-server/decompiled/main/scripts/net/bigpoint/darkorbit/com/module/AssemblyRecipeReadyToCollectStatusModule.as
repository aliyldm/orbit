package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AssemblyRecipeReadyToCollectStatusModule extends AssemblyRecipeStatusModule
   {
      
      private static var _instance:AssemblyRecipeReadyToCollectStatusModule;
      
      public var prevBuildCount:int = 0;
      
      public var buildAmount:Number = 0;
      
      public function AssemblyRecipeReadyToCollectStatusModule(param1:Number = 0, param2:int = 0)
      {
         super();
         this.prevBuildCount = param2;
         this.buildAmount = param1;
      }
      
      public static function get instance() : AssemblyRecipeReadyToCollectStatusModule
      {
         return _instance || (_instance = new AssemblyRecipeReadyToCollectStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return 7715;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 12;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.prevBuildCount = param1.readInt();
         this.prevBuildCount = this.prevBuildCount >>> 12 % 32 | this.prevBuildCount << 32 - 12 % 32;
         this.buildAmount = param1.readDouble();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(7715);
         super.write(param1);
         param1.writeInt(this.prevBuildCount << 12 % 32 | this.prevBuildCount >>> 32 - 12 % 32);
         param1.writeDouble(this.buildAmount);
      }
   }
}

