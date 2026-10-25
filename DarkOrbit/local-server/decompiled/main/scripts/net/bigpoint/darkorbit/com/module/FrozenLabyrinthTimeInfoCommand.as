package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class FrozenLabyrinthTimeInfoCommand implements IModule
   {
      
      private static var _instance:FrozenLabyrinthTimeInfoCommand;
      
      public var timeToEndLabyrinth:Number = 0;
      
      public var timeToNextLabyrinth:Number = 0;
      
      public function FrozenLabyrinthTimeInfoCommand(param1:Number = 0, param2:Number = 0)
      {
         super();
         this.timeToEndLabyrinth = param1;
         this.timeToNextLabyrinth = param2;
      }
      
      public static function get instance() : FrozenLabyrinthTimeInfoCommand
      {
         return _instance || (_instance = new FrozenLabyrinthTimeInfoCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 10104;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 16;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.timeToEndLabyrinth = param1.readDouble();
         this.timeToNextLabyrinth = param1.readDouble();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(10104);
         param1.writeDouble(this.timeToEndLabyrinth);
         param1.writeDouble(this.timeToNextLabyrinth);
      }
   }
}

