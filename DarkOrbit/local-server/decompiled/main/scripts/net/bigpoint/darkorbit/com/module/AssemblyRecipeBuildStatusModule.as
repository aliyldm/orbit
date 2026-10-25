package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AssemblyRecipeBuildStatusModule extends AssemblyRecipeStatusModule
   {
      
      private static var _instance:AssemblyRecipeBuildStatusModule;
      
      public var buildAmount:Number = 0;
      
      public var remainingTimeMillis:Number = 0;
      
      public var prevBuildCount:int = 0;
      
      public function AssemblyRecipeBuildStatusModule(param1:Number = 0, param2:Number = 0, param3:int = 0)
      {
         super();
         this.buildAmount = param2;
         this.remainingTimeMillis = param1;
         this.prevBuildCount = param3;
      }
      
      public static function get instance() : AssemblyRecipeBuildStatusModule
      {
         return _instance || (_instance = new AssemblyRecipeBuildStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -4951;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 20;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.buildAmount = param1.readDouble();
         this.remainingTimeMillis = param1.readDouble();
         this.prevBuildCount = param1.readInt();
         this.prevBuildCount = this.prevBuildCount << 9 % 32 | this.prevBuildCount >>> 32 - 9 % 32;
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-4951);
         super.write(param1);
         param1.writeDouble(this.buildAmount);
         param1.writeDouble(this.remainingTimeMillis);
         param1.writeInt(this.prevBuildCount >>> 9 % 32 | this.prevBuildCount << 32 - 9 % 32);
      }
   }
}

