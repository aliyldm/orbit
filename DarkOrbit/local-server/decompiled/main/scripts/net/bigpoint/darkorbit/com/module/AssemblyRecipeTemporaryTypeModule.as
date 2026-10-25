package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class AssemblyRecipeTemporaryTypeModule extends AssemblyRecipeTypeModule
   {
      
      private static var _instance:AssemblyRecipeTemporaryTypeModule;
      
      public var remainingTimeMillis:Number = 0;
      
      public function AssemblyRecipeTemporaryTypeModule(param1:Number = 0)
      {
         super();
         this.remainingTimeMillis = param1;
      }
      
      public static function get instance() : AssemblyRecipeTemporaryTypeModule
      {
         return _instance || (_instance = new AssemblyRecipeTemporaryTypeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -22814;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.remainingTimeMillis = param1.readDouble();
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-22814);
         super.write(param1);
         param1.writeDouble(this.remainingTimeMillis);
      }
   }
}

