package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class AlignmentModule implements IModule
   {
      
      private static var _instance:AlignmentModule;
      
      public static const ALIGNMENT_NORTH:int = 0;
      
      public static const ALIGNMENT_NORT_EAST:int = 1;
      
      public static const ALIGNMENT_EAST:int = 2;
      
      public static const ALIGNMENT_SOUTH_EAST:int = 3;
      
      public static const ALIGNMENT_SOUTH:int = 4;
      
      public static const ALIGNMENT_SOUTH_WEST:int = 5;
      
      public static const ALIGNMENT_WEST:int = 6;
      
      public static const ALIGNMENT_NORTH_WEST:int = 7;
      
      public static const ALIGNMENT_CENTER:int = 8;
      
      public static const ALIGNMENT__MAX:int = 9;
      
      public var alignmentValue:int = 0;
      
      public function AlignmentModule(param1:int = 0)
      {
         super();
         this.alignmentValue = param1;
      }
      
      public static function get instance() : AlignmentModule
      {
         return _instance || (_instance = new AlignmentModule());
      }
      
      public function getLibcomModuleId() : int
      {
         return 152;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.alignmentValue = param1.readShort();
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(152);
         param1.writeShort(this.alignmentValue);
      }
   }
}

