package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class Curcubitor2019TimeUpdateCommand implements IModule
   {
      
      private static var _instance:Curcubitor2019TimeUpdateCommand;
      
      public var timeToNext:Number = 0;
      
      public function Curcubitor2019TimeUpdateCommand(param1:Number = 0)
      {
         super();
         this.timeToNext = param1;
      }
      
      public static function get instance() : Curcubitor2019TimeUpdateCommand
      {
         return _instance || (_instance = new Curcubitor2019TimeUpdateCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 17829;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 8;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeToNext = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(17829);
         param1.writeDouble(this.timeToNext);
      }
   }
}

