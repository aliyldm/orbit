package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import net.bigpoint.com.module.IModule;
   
   public class POIVisualModifierCommand implements IModule
   {
      
      private static var _instance:POIVisualModifierCommand;
      
      public var poiId:String = "";
      
      public var visualModifier:VisualModifierCommand;
      
      public function POIVisualModifierCommand(param1:String = "", param2:VisualModifierCommand = null)
      {
         super();
         this.poiId = param1;
         if(param2 == null)
         {
            this.visualModifier = new VisualModifierCommand();
         }
         else
         {
            this.visualModifier = param2;
         }
      }
      
      public static function get instance() : POIVisualModifierCommand
      {
         return _instance || (_instance = new POIVisualModifierCommand());
      }
      
      public function getLibcomModuleId() : int
      {
         return 3530;
      }
      
      public function getLibcomModuleEstimatedLength() : int
      {
         return 2;
      }
      
      public function read(param1:IDataInput) : void
      {
         this.poiId = param1.readUTF();
         this.visualModifier = VisualModifierCommand(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.visualModifier)
         {
            this.visualModifier.read(param1);
         }
      }
      
      public function write(param1:IDataOutput) : void
      {
         param1.writeShort(3530);
         param1.writeUTF(this.poiId);
         if(null != this.visualModifier)
         {
            this.visualModifier.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

