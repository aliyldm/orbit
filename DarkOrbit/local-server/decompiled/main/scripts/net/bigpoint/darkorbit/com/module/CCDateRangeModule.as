package net.bigpoint.darkorbit.com.module
{
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   
   public class CCDateRangeModule extends CCAbstractRangeModule
   {
      
      private static var _instance:CCDateRangeModule;
      
      public var maxDate:CCDateValueModule;
      
      public var minDate:CCDateValueModule;
      
      public function CCDateRangeModule(param1:CCDateValueModule = null, param2:CCDateValueModule = null)
      {
         super();
         if(param2 == null)
         {
            this.maxDate = new CCDateValueModule();
         }
         else
         {
            this.maxDate = param2;
         }
         if(param1 == null)
         {
            this.minDate = new CCDateValueModule();
         }
         else
         {
            this.minDate = param1;
         }
      }
      
      public static function get instance() : CCDateRangeModule
      {
         return _instance || (_instance = new CCDateRangeModule());
      }
      
      override public function getLibcomModuleId() : int
      {
         return -28042;
      }
      
      override public function getLibcomModuleEstimatedLength() : int
      {
         return 0;
      }
      
      override public function read(param1:IDataInput) : void
      {
         param1.readShort();
         super.read(param1);
         this.maxDate = CCDateValueModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.maxDate)
         {
            this.maxDate.read(param1);
         }
         this.minDate = CCDateValueModule(ModuleFactory.get().createInstance(param1.readShort()));
         if(null != this.minDate)
         {
            this.minDate.read(param1);
         }
      }
      
      override public function write(param1:IDataOutput) : void
      {
         param1.writeShort(-28042);
         super.write(param1);
         if(null != this.maxDate)
         {
            this.maxDate.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
         if(null != this.minDate)
         {
            this.minDate.write(param1);
         }
         else
         {
            param1.writeShort(0);
         }
      }
   }
}

