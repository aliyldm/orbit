package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AssemblyRecipeAvailableStatusModule extends AssemblyRecipeStatusModule
   {
      
      private static var _instance:AssemblyRecipeAvailableStatusModule;
      
      public var currentBuildCount:int = 0;
      
      public var isNew:Boolean = false;
      
      public function AssemblyRecipeAvailableStatusModule(param1:Boolean = false, param2:int = 0)
      {
         super();
         this.currentBuildCount = param2;
         this.isNew = param1;
      }
      
      public static function get instance() : AssemblyRecipeAvailableStatusModule
      {
         return _instance || (_instance = new AssemblyRecipeAvailableStatusModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -19899;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 5;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.currentBuildCount = param1.readInt();
         this.currentBuildCount = this.currentBuildCount >>> 2 % 32 | this.currentBuildCount << 32 - 2 % 32;
         this.isNew = param1.readBoolean();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-19899);
         super.write(param1);
         param1.writeInt(this.currentBuildCount << 2 % 32 | this.currentBuildCount >>> 32 - 2 % 32);
         param1.writeBoolean(this.isNew);
      }
   }
}

