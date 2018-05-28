<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Modelos\Softland\CP_TCargaOrdenProduccion;
use App\Modelos\Softland\PEDIDO;
use App\Modelos\ControlPiso\CP_EQUIPOARTICULO;
use App\Modelos\ControlPiso\CP_CALENDARIO_PLANIFICADOR;
use App\Modelos\ControlPiso\CP_CALENDARIO_PLANIFICADOR_DETALLE;
use App\Modelos\ControlPiso\CP_TEMP_PLANIFICACION;
use App\Modelos\ControlPiso\CP_TEMP_PLANIFICACION_ENCA;
use App\Modelos\ControlPiso\CP_ENCABEZADOPLANIFICACION;
use App\Modelos\ControlPiso\CP_DETALLEPLANIFICACION;
use App\Modelos\ControlPiso\CP_PLANIFICACION;
use App\Modelos\ControlPiso\CP_tasks;
use App\Modelos\ControlPiso\CP_events;
use App\Modelos\Softland\ESTRUC_PROCESO;
use App\Modelos\ControlPiso\CP_globales;
use App\Modelos\ControlPiso\CP_emails;
use App\Modelos\Softland\EQUIPO;
use App\Modelos\Softland\TIPO_EQUIPO;
use App\Modelos\ControlCalidad\FT_FICHA;
use Illuminate\Support\Facades\DB;
use App\Mail\Produccion;
Use Carbon\Carbon;
use Illuminate\Support\Facades\Input;
use Illuminate\Support\Facades\Mail;

class OrdenProduccionController extends Controller
{
    /**
     * Display a listing of the resource.
     *
     * @return \Illuminate\Http\Response
     */
   public function __construct()
    {
     
        if(!\Session::has('cart'))\Session::put('cart',array());
    }

    public function index()
    {
      
      
        $OrdenProduccion=CP_TCargaOrdenProduccion::whereColumn('CANTIDAD_ARTICULO','>','CANTIDAD_PRODUCCI')->get();
        return view('ControPiso.Transacciones.listado_orden_produccion')
               ->with('OrdenProduccion',$OrdenProduccion);
        //
           
    }

    public function EliminarProduccion($id){
      
        $orden=CP_TCargaOrdenProduccion::where('id','=',$id);
        $orden->delete();

        flash("Se ha eliminado la orden Produccion  de forma existosa",'danger')->important();
     
        return redirect()->route('Produccion.index');
    }


    public function ConsultaProduccion(){

      $OrdenProduccion=CP_PLANIFICACION::all();
       return view('ControPiso.Consulta.orderproduccion')
               ->with('OrdenProduccion',$OrdenProduccion);
    }
    /**
     * Show the form for creating a new resource.
     *
     * @return \Illuminate\Http\Response
     */
    public function create()
    {
        return 'Text';
    }

    /**
     * Store a newly created resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
     
    }

    /**
     * Display the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function show($id)
    {
       
    }

    /**
     * Show the form for editing the specified resource.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function edit($id)
    {
        
    }

    /**
     * Update the specified resource in storage.
     *
     * @param  \Illuminate\Http\Request  $request
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function update(Request $request, $id)
    {
        
    }

    /**
     * Remove the specified resource from storage.
     *
     * @param  int  $id
     * @return \Illuminate\Http\Response
     */
    public function destroy($id)
    {
        
    }

    public function planificacion(  $id){
   
         CP_TEMP_PLANIFICACION::where('USUARIOCREACION','=',\Auth::user()->name )
         ->delete();
        CP_TEMP_PLANIFICACION_ENCA::where('USUARIO','=',\Auth::user()->name )
         ->delete();


          //$globales=CP_globales::get()->pluck('produccdetallada');
          $globales = CP_globales::max('produccdetallada');

          if($globales=="S"){

              $ordenproduccion=CP_TCargaOrdenProduccion::where('ORDEN_PRODUCCION', $id)->first();;
              $articulordproduccion=$ordenproduccion->ARTICULO;
              $pedido=PEDIDO::where('ESTADO','=','A')->where('PEDIDO','like','PCEX%') ->orderby('PEDIDO','asc')->get();
              
              $centrocosto=DB::Connection()->select("select SECUENCIA,DESCRIPCION,OPERACION from IBERPLAS.ESTRUC_PROCESO 
              where ARTICULO='$articulordproduccion' AND version in (
              select version from IBERPLAS.ESTRUC_MANUFACTURA where ARTICULO='$articulordproduccion' AND estado='A') order by SECUENCIA");
              
              //$centrocosto=ESTRUC_PROCESO::selectRaw('SECUENCIA,DESCRIPCION,OPERACION')
               // ->where('ARTICULO','=',$articulordproduccion)
                //->where('REPORTA_PROD','=','N')
                //->Groupby('SECUENCIA','DESCRIPCION','OPERACION')->get();

              $ft_ficha=FT_FICHA::where('ARTICULO','=',$articulordproduccion)->get();
              return view('ControPiso.Transacciones.planificacion')
              ->with('ordenproduccion',$ordenproduccion)
              ->with('pedido',$pedido)
              ->with('centrocosto',$centrocosto)
              ->with('ft_ficha',$ft_ficha);
          }else{

              $ordenproduccion=CP_TCargaOrdenProduccion::where('ORDEN_PRODUCCION', $id)->first();;
              $articulordproduccion=$ordenproduccion->ARTICULO;
              $pedido=PEDIDO::where('ESTADO','=','A')->orderby('PEDIDO','asc')->get();
             $centrocosto=CP_EQUIPOARTICULO::where('ARTICULO','=',$articulordproduccion)->
             where('operacion','=','TERMINADO')->get();
             $ft_ficha=FT_FICHA::where('ARTICULO','=',$articulordproduccion)->get();

              return view('ControPiso.Transacciones.planificacion02')
              ->with('ordenproduccion',$ordenproduccion)
              ->with('pedido',$pedido)
              ->with('centrocosto',$centrocosto)
              ->with('ft_ficha',$ft_ficha);


          }




        


    }

    public function ConsultaPedidos(Request $request,$id){

        
        $pedido=PEDIDO::where('PEDIDO','=',$id)->get();
         return   json_encode ($pedido);

        


    }

    public function ConsultaMaquina(Request $request){
    
    //$id=centrocosto,$id2=articulo,$id3=descripcion operacion
      $id=$_GET['id'];
      $id2=$_GET['id2'];
      $id3=$_GET['id3'];

     
      //$centrocosto=CP_EQUIPOARTICULO::
     // where('ID','=',$id)->
     // get();
      
      $centrocosto=DB::Connection()->select("SELECT  PROCESO.CANT_PRODUCIDA_PT,PROCESO.HORAS_STD_MOE,
      RUBRO.ARTICULO,RUBRO.OPERACION,PROCESO.DESCRIPCION, 
      RUBRO.RUBRO,
      CASE  PROCESO.CP_TIEMPOCAMBIOMOLDE WHEN NULL THEN PROCESO.CP_TIEMPOCAMBIOMOLDE ELSE 0.0  END as CP_TIEMPOCAMBIOMOLDE ,
      (PROCESO.CANT_PRODUCIDA_PT/PROCESO.HORAS_STD_MOE) AS HORASXHORA
            FROM 
            IBERPLAS.ESTRUC_PROC_RUBRO RUBRO,
            IBERPLAS.ESTRUC_PROCESO PROCESO
            WHERE 
            PROCESO.ARTICULO=RUBRO.ARTICULO AND
            PROCESO.VERSION IN(SELECT VERSION FROM IBERPLAS.ESTRUC_MANUFACTURA WHERE ESTADO='A' AND ARTICULO='$id2')AND    
            RUBRO.ARTICULO='$id2' AND 
            PROCESO.ARTICULO='$id2' AND
            RUBRO.OPERACION=PROCESO.OPERACION and
            PROCESO.DESCRIPCION='$id3' AND
            PROCESO.EQUIPO='$id' AND
            RUBRO.VERSION IN (SELECT VERSION FROM IBERPLAS.ESTRUC_MANUFACTURA WHERE ESTADO='A' AND ARTICULO='$id2')
      ");

     //  dd($centrocosto);
      return json_encode($centrocosto);

    }

    public function ConsultaMaquina02($id,$id2){
    
    //$id=maquinaria,$id2=articulo
     
      $centrocosto=CP_EQUIPOARTICULO::
      where('EQUIPO','=',$id)->
      where('ARTICULO','=',$id2)
      ->get();
     
      return json_encode($centrocosto);
    }


    public function planificar($id,$id4,$id5,$id6,$id8,Request $request){
      
    $cantidadproducir=$request->id_cantidadaproducir;
    $id3=$request->Mid_opera;
    
    $normal =$request->admin;

  
    
    $secuencia=$request->id_secuencia;
     $secuencia2=$request->id_secuencia;
    $orden=$request->norden;
    $cantidadxhora=$request->idm_cantidadxh;
    $cantidadxhora2=$request->idm_cantidadxh;
    $ficha_tenica=$id8;


  
    
    $hora=date('H',strtotime($id5) );
    $min=date('i',strtotime($id5) );
      
   
      
        $fechaActual=Carbon::now();

        $nueva=date('Y-m-d', strtotime($id4));
        $nueva2=date('Y-m-d', strtotime($id4));
        


   

       // consultar si existe registros en la tabla de transacciones para obtener el ultimo correlativo segun maquina y operacion
         
      

        $core=DB::Connection()->select("select ID from IBERPLAS.CP_CALENDARIO_PLANIFICADOR_detalle
                                      where fecha='$nueva2' and DATEPART(HOUR,hora)='$hora'");

                                  
                     


       
       

        foreach ($core as $core) {
          
          $valorinicial=$core->ID;
        }


        

        
          

        
         $equipo=$id6;

       
 

       //revisar si hay disponibilaid este fecha
       
      // $disponi=DB::Connection()->select("select * from IBERPLAS.CP_CALENDARIO_PLANIFICADOR_DETALLE
                                          //where 
                                           //ID  in(
                                          //select calendario_id from IBERPLAS.CP_DETALLEPLANIFICACION
                                          //where centrocosto='$equipo' and fecha='$nueva2' and DATEPART(HOUR,hora)='$hora')");

          $disponi=DB::Connection()->select("
                                          select calendario_id from IBERPLAS.CP_DETALLEPLANIFICACION
                                          where centrocosto='$equipo' and fecha='$nueva2' and DATEPART(HOUR,hora)='$hora'");

         //dd($disponi);                                 
       


        if(count($disponi)>0){
            $inicio=CP_DETALLEPLANIFICACION::where('centrocosto','=',$equipo)->max('calendario_id');    
           $inicioturno=$inicio+1;

          if (is_null($normal)){
               
            $arr=array($request->lunes_ta,$request->martes_ta,$request->miercoles_ta,$request->jueves_ta,$request->viernes_ta,$request->sabado_ta,$request->domingo_ta,
            $request->lunes_tb,$request->martes_tb,$request->miercoles_tb,$request->jueves_tb,$request->viernes_tb,$request->sabado_tb,$request->domingo_tb,
            $request->lunes_tc,$request->martes_tc,$request->miercoles_tc,$request->jueves_tc,$request->viernes_tc,$request->sabado_tc,$request->domingo_tc,);
            $turnosasigados=$this->calcularTurnos($normal,$cantidadproducir,$id8,$cantidadxhora2,$secuencia2,$id6,$id,$inicioturno,$arr,$id3,$id4,$secuencia,$orden,$cantidadxhora);

          }else{

         
            $arr=array($request->lunes_tad,$request->martes_tad,$request->miercoles_tad,$request->jueves_tad,$request->viernes_tad,$request->sabado_tad,$request->domingo_tad,);
            
            $turnosasigados=$this->calcularTurnos($normal,$cantidadproducir,$id8,$cantidadxhora2,$secuencia2,$id6,$id,$inicioturno,$arr,$id3,$id4,$id5,$secuencia,$orden,$cantidadxhora);
          }

       
             
         return   json_encode ($turnosasigados);


        } else
        {
       
          $inicioturno=$valorinicial;
         
          
          if (is_null($normal)){
           // dd('no se admin');
           // dd('admin no selecionado');
           
          $arr=array($request->lunes_ta,$request->martes_ta,$request->miercoles_ta,$request->jueves_ta,$request->viernes_ta,$request->sabado_ta,$request->domingo_ta,
                    $request->lunes_tb,$request->martes_tb,$request->miercoles_tb,$request->jueves_tb,$request->viernes_tb,$request->sabado_tb,$request->domingo_tb,
                    $request->lunes_tc,$request->martes_tc,$request->miercoles_tc,$request->jueves_tc,$request->viernes_tc,$request->sabado_tc,$request->domingo_tc,);

          
           $turnosasigados=$this->calcularTurnos($normal,$cantidadproducir,$id8,$cantidadxhora2,$secuencia2,$id6,$id,$inicioturno,$arr, $id3,$id4,$id5,$secuencia,$orden,$cantidadxhora);

          }else{
            //dd('si es admin');

             //dd('admin selecionado');
             $arr=array($request->lunes_tad,$request->martes_tad,$request->miercoles_tad,$request->jueves_tad,$request->viernes_tad,$request->sabado_tad,$request->domingo_tad,);
            
              $turnosasigados=$this->calcularTurnos($normal,$cantidadproducir,$id8,$cantidadxhora2,$secuencia2,$id6,$id,$inicioturno,$arr,$id3,$id4,$id5,$secuencia,$orden,$cantidadxhora);
          }

       
             
         return   json_encode ($turnosasigados);
        }
        
    }

    


    public function calcularTurnos($normal,$cantidadproducir,$id8,$cantidadxhora2,$secuencia2,$id6,$id,$inicioturno,$arr,$id3,$id4,$secuencia,$orden,$cantidadxhora){
        

      
             
         CP_TEMP_PLANIFICACION::where('USUARIOCREACION','=',\Auth::user()->name )
         ->where('operacion','=',$id3)->delete();
         
         CP_TEMP_PLANIFICACION_ENCA:: where('usuario','=',\auth::user()->name)
         ->where('operacion','=',$id3)->delete();

         $equipo=$id6;
         
         

      //   foreach ($centrocosto as $centrocosto) {
           
        //   $equipo=$centrocosto->EQUIPO;
         //}

         

         $tempo=CP_TEMP_PLANIFICACION::where('centrocosto','=',$equipo)->max('calendario_id');
         
       
         if($tempo>0){
            
          if (is_null($normal)){

            $turnos2=CP_CALENDARIO_PLANIFICADOR_DETALLE::whereNull('ESTADO')
            ->where('ID','>',$tempo)
            ->whereIN('turnodia',$arr)
            ->get(); 

          }else{}
            

            $turnos2=CP_CALENDARIO_PLANIFICADOR_DETALLE::whereNull('ESTADO')
            ->where('ID','>=',$inicioturno)
            ->where('tipo','=','A')
            ->whereIN('dia',$arr)
            ->get();    
               

               // }
         }else{
             

          if (is_null($normal)){
           
           //dd('valor nulo');
           $turnos2=CP_CALENDARIO_PLANIFICADOR_DETALLE::whereNull('ESTADO')
           ->where('ID','>=',$inicioturno)
           ->whereIN('turnodia',$arr)
           ->get();
            


           
     
           
           
           } else {
           // dd('valor no nulo');
           
           $turnos2=CP_CALENDARIO_PLANIFICADOR_DETALLE::whereNull('ESTADO')
          -> where('ID','>=',$inicioturno)
           ->where('tipo','=','A')
           ->whereIN('dia',$arr)
           ->get();
          // dd($turnos2);
           
     
          
          }
          

              
                               
       //}


      }
      
      // Consultar Tabla donde registro el detalle de la planificacion para  no incluir aquellos correlativos que ya han sido reervados ejemplo mantenimiento y otros.
      // 

       
       
     
         
      


     
         
          $conta=0;              
          $vcantidad=0;
          $cantidad2=0;
          
        
         foreach ($turnos2 as $turnos) {
  
            

             $conta=$conta+1;

             if($conta==$id+1){
              
                 
               break;
             
             
             } else{
              
              if($conta==$id){
                $vcantidad=$cantidadproducir-$cantidad2;
              }else{
                $vcantidad=$cantidadxhora2;
                $cantidad2=$vcantidad+$cantidad2;
              }

              if (is_null($normal)){ $turno=$turnos->turno;}
             
              else{ 
             $turno="4";
            };

              

                $plantemp=new CP_TEMP_PLANIFICACION;
                $plantemp->hora=$turnos->hora;
                $plantemp->orden=$turnos->orden;
               
                $plantemp->turno=$turno;
                $plantemp->fecha=date("d-m-Y",strtotime($turnos->fecha));
                $plantemp->fechaCalendario=date("d-m-Y H:i:s",strtotime( $turnos->fechaCalendario));
              
                $plantemp->operacion=$id3;
                $plantemp->centrocosto=$equipo;
                $plantemp->secuencia=$secuencia2;
                $plantemp->calendario_id=$turnos->ID;
                $plantemp->orden_prod=$orden;
                $plantemp->cantidadxhora=$vcantidad;
                $plantemp->FICHA_TECNICA=$id8;
                $plantemp->USUARIOCREACION=\Auth::user()->name;
                  $plantemp->save();




              //$turnosasigados[]= $turnos2;
              //$turnosasigados[]= $valor;
              
             }
            
         }
        


     $usuario=\Auth::user()->name;

     $turnosasigados=DB::Connection()->select("select min(calendario_id) as Horaini,MAX(calendario_id) as HoraFin,count(orden) as horas,sum(cantidadxhora) as cantidad,turno,fecha,operacion,centrocosto,secuencia,ficha_tecnica 
from IBERPLAS.CP_TEMP_PLANIFICACION
where  
USUARIOCREACION='$usuario' group by turno,fecha,operacion,centrocosto,secuencia,ficha_tecnica order by  secuencia,operacion,fecha,turno");
        
          CP_TEMP_PLANIFICACION_ENCA:: where('usuario','=',\auth::user()->name)
         ->delete();



        foreach ($turnosasigados as $turnos) {
          
          $encatemp=new CP_TEMP_PLANIFICACION_ENCA;
          $encatemp->horaini=$turnos->Horaini;
          $encatemp->horafin=$turnos->HoraFin;
          $encatemp->horas=$turnos->horas;
          $encatemp->cantidad=$turnos->cantidad;
          $encatemp->turno=$turnos->turno;
          $encatemp->fecha=$turnos->fecha;
         // $encatemp->fechaCalendario=date("Y-m-d H:i:s",strtotime( $turnos->fechaCalendario));        
          $encatemp->operacion=$turnos->operacion;
          $encatemp->centrocosto=$turnos->centrocosto;
          $encatemp->secuencia=$turnos->secuencia;
          $encatemp->FICHA_TECNICA=$id8;
          $encatemp->USUARIO=\Auth::user()->name;
          $encatemp->save();
          $conta=$conta+1;
        }

        
       
      // actualizar horas en temporal
      // recorremos la tabla de encabezado tempral
      // 
      $encatem= CP_TEMP_PLANIFICACION_ENCA::get();
      
      

           foreach ($encatem as $value) {

            $horaini=$value->horaini;
            $horafin=$value->horafin;
            $thoraini=CP_CALENDARIO_PLANIFICADOR_DETALLE::where ('ID','=',$horaini)->select('hora','fechahora')->get();
            $thorafin=CP_CALENDARIO_PLANIFICADOR_DETALLE::where ('ID','=',$horafin)->select('hora','fechahora')->get();

         
             foreach ($thoraini as $value) {

               //$nueva2=date('Y-m-d', strtotime($id4));
               $hora=$value->hora;
               $fhora=date('Y-d-m H:i:s',strtotime($value->fechahora));
                           CP_TEMP_PLANIFICACION_ENCA::where('horaini','=',$horaini)->update(['thoraini'=>$hora,'fhoraini'=>$fhora]);
             }

              foreach ($thorafin as $value) {
               $hora=$value->hora;
               $fhora=date('Y-d-m H:i:s',strtotime($value->fechahora));
                           CP_TEMP_PLANIFICACION_ENCA::where('horafin','=',$horafin)->update(['thorafin'=>$hora,'fhorafin'=>$fhora]);
             }

           }

         
         $turnosasigados= CP_TEMP_PLANIFICACION_ENCA::get();        


        return $turnosasigados;

    }






    public function guardar_planificacion(Request $request){

            //$Inputs=Input::all();
            //
            
            //Dias de la semana 
            $lunes=$request->lunes;
            $martes=$request->martes;
            $miercoles=$request->miercoles;
            $jueves=$request->jueves;
            $viernes=$request->viernes;
            $sabado=$request->sabado;
            $domingo=$request->domingo;

            $normal=$request->normal;

            $cant=$request->id_cantidadaproducir;






           
                   


        
              $date = carbon::now();
             $date = $date->format('d-m-Y H:i:s');

             
              $fechaplanificada=$request->id_fecha;
              $fechaplanificada=date("d-m-Y", strtotime($fechaplanificada)) ;

               $maximo=CP_PLANIFICACION::max('id');

               if($maximo==null){
                $maximo=1;
               }
              
             $encatem=CP_TEMP_PLANIFICACION_ENCA::all();
             
             foreach ($encatem as $value) {
             
               $fechai=$value->fhoraini;
               $fechaf=$value->fhorafin;
               $fecha=$value->fecha;

               $fechai=date("d-m-Y H:i:s",strtotime($fechai));
               $fechaf=date("d-m-Y H:i:s",strtotime($fechaf));
               $fecha01=date("d-m-Y",strtotime($fecha));
               
               $planificacion=new CP_ENCABEZADOPLANIFICACION  ;  
                $planificacion->ordenproduccion=$request->norden;
                $planificacion->pedido=$request->id_pedido;
                $planificacion->articulo=$request->articulo;
                $planificacion->horaini=$value->horaini;
               $planificacion->horafin=$value->horafin;
               $planificacion->thoraini=$value->thoraini;
               $planificacion->thorafin=$value->thorafin;
              $planificacion->fhoraini=$fechai;
              $planificacion->fhorafin=$fechaf;
                $planificacion->horas=$value->horas;
                $planificacion->cantidad=$value->cantidad;
                $planificacion->turno=$value->turno;
                $planificacion->fecha=$fecha01;
                $planificacion->operacion=$value->operacion;
                $planificacion->centrocosto=$value->centrocosto;
                $planificacion->secuencia=$value->secuencia;
                $planificacion->estado='P';
                 $planificacion->ficha_tecnica=$value->ficha_tecnica;
                $planificacion->USUARIOCREACION=\Auth::user()->name;
                $planificacion->FECHACREACION=$date;
                $planificacion->save();
                





             

              } 




              //vemos las tareas para el gannt
              

           



             
            

             

            // Grabamos el detalle de planificacion
                  $nueva=date('d-m-Y', strtotime($request->id_fecha));


                 $orden_cantidad=CP_TCargaOrdenProduccion::where('ORDEN_PRODUCCION','=',$request->norden)->get();

                
                 foreach ($orden_cantidad as $orden_cantidad) {
                      
                      $cantidad=$orden_cantidad->CANTIDAD_PRODUCCI;
                      $cantidad2=$cantidad+$cant;
                    }   
                 
                 

                 CP_TCargaOrdenProduccion::where('ORDEN_PRODUCCION','=',$request->norden)->update(['CANTIDAD_PRODUCCI'=>$cantidad2]);




          
               
               $detalleplanificacion=new CP_DETALLEPLANIFICACION;
                    
               $tempdetalle=CP_TEMP_PLANIFICACION::all();

               foreach ($tempdetalle as $value) {
                
                $detall=new CP_DETALLEPLANIFICACION;
                 $detall->calendario_id=$value->calendario_id;
                 $detall->orden_prod=$value->orden_prod;
                 $detall->ordenproduccion=$request->norden;
                 $detall->hora=$value->hora;
                 $detall->orden=$value->orden;
                 $detall->turno=$value->turno;
                 $detall->fecha= date("d-m-Y H:i:s",strtotime( $value->fecha));;
                 $detall->fechaCalendario= date("d-m-Y H:i:s",strtotime( $value->fechaCalendario));
                 $detall->operacion=$value->operacion;
                 $detall->centrocosto=$value->centrocosto;
                 $detall->secuencia=$value->secuencia;
                 $detall->FICHA_TECNICA=$value->FICHA_TECNICA;
                 $detall->cantidadxhora=$value->cantidadxhora;
                 $detall->USUARIOCREACION=\Auth::user()->name;
                 $detall->FECHACREACION=$date;
                 $detall->save();



                }              


           CP_TEMP_PLANIFICACION_ENCA::where('USUARIO','=',\Auth::user()->name )
         ->delete();
         CP_TEMP_PLANIFICACION::where('USUARIOCREACION','=',\Auth::user()->name )
         ->delete();
               

          $plan=DB::Connection()->select("select operacion ,ordenproduccion,articulo,MIN(horaini) as fechamin ,MAX(horafin) as fechamax,
            SUM(cantidad) as cantidad,sum(horas) as horas,centrocosto ,pedido,FICHA_TECNICA
            from IBERPLAS.CP_ENCABEZADOPLANIFICACION
            where ordenproduccion='$request->norden'
            group by operacion,ordenproduccion,articulo,secuencia,centrocosto,pedido,FICHA_TECNICA
            order by secuencia");

           foreach ($plan as $value) {
             $fecha1=CP_CALENDARIO_PLANIFICADOR_DETALLE::where('id',$value->fechamin)->get();
             $fecha2=CP_CALENDARIO_PLANIFICADOR_DETALLE::where('id',$value->fechamax)->get();
          
             

             foreach ($fecha1 as $fecha1) {
               $fechai=date("d-m-Y H:i:s",strtotime($fecha1->fechahora));   
               $fechaci=date("d-m-Y H:i:s",strtotime($fecha1->fechaCalendario));
             }

             foreach ($fecha2 as $fecha2) {
              $fechaf=date("d-m-Y H:i:s",strtotime($fecha2->fechahora));
              $fechacf=date("d-m-Y H:i:s",strtotime($fecha2->fechaCalendario)); 
             }
            
           // dd($fechai);
            $CP_PLANIFICACION=new CP_PLANIFICACION;
            $CP_PLANIFICACION->operacion=$value->operacion;
            $CP_PLANIFICACION->ordenproduccion=$value->ordenproduccion;
            $CP_PLANIFICACION->articulo=$value->articulo;
            $CP_PLANIFICACION->fechamin=$fechai;
            $CP_PLANIFICACION->fechamax=$fechaf;
            $CP_PLANIFICACION->fechaCalendariomin=$fechaci;
             $CP_PLANIFICACION->fechaCalendariomax=$fechacf;
            $CP_PLANIFICACION->cantidad=$value->cantidad;
            $CP_PLANIFICACION->centrocosto=$value->centrocosto;
            $CP_PLANIFICACION->pedido=$value->pedido;
            $CP_PLANIFICACION->estado='P';
            $CP_PLANIFICACION->horas=$value->horas;
            $CP_PLANIFICACION->porcentaje=0;
            $CP_PLANIFICACION->FICHA_TECNICA=$value->FICHA_TECNICA;
            $CP_PLANIFICACION->USUARIOCREACION=\Auth::user()->name;
            $CP_PLANIFICACION->FECHACREACION=$date;
            $CP_PLANIFICACION->save();

            
           }
            //mandar mail de orden de produccion Planificado
           $ordenproduccion2=$request->norden;
          
          //para no enviar correo
          $cp_planificacion2=CP_PLANIFICACION::where('ordenproduccion','=',$request->norden)->get();
           $emails=CP_emails::where('email01','=','S')->select('email')->get();  
           Mail::to($emails)->send(new Produccion($cp_planificacion2,$ordenproduccion2));
             
           

           $gannt=DB::Connection()->
           select("select ('ORDEN='+PLA.ordenproduccion+'-'+'ARTICULO='+ART.ARTICULO+'-'+ART.DESCRIPCION) as text,min(PLA.fechamin) fechamin, SUM(PLA.horas) as horas ,PLA.centrocosto as centrocosto
           from 
           IBERPLAS.CP_PLANIFICACION PLA,
           IBERPLAS.ARTICULO ART
           where
           PLA.articulo=ART.ARTICULO AND 
           ordenproduccion='$ordenproduccion2'
           group by 
           PLA.ordenproduccion,
           ART.ARTICULO,
           ART.DESCRIPCION,
           PLA.centrocosto" );


          foreach ($gannt as $value) {
           $fecha=date("d-m-Y H:i:s",strtotime($value->fechamin));
            $task=new cp_tasks;
            $task->text=$value->text;
            $task->duration=$value->horas;
            $task->progress=0.25;
            $task->start_date=$fecha;
            $task->centrocosto=$value->centrocosto;
            $task->ordenproduccion=$ordenproduccion2;
            $task->save(); 
          }
           





           //ESTADOS P=PLANIIFICACO,A=EN PROCESO,B=FINALIZADA,C=CERRADA,D=LIQUIDADA


              $iddetalle=DB::Connection()->select("select operacion,FECHACREACION 
                          from IBERPLAS.CP_ENCABEZADOPLANIFICACION 
                          where planificacion_id is null
                          group by operacion ,FECHACREACION");
 

            
              foreach ($iddetalle as $value) {

                $operacion=$value->operacion;
                $fecha=$value->FECHACREACION;



                 
                 
                $idpla=CP_PLANIFICACION::where('operacion','=',$operacion)->where('FECHACREACION','=',$date)->select('id')->orderby('id', 'desc')->get();

                 foreach ($idpla as $value) {

                   
                   $id=$value->id;
                   CP_ENCABEZADOPLANIFICACION::where('operacion','=',$operacion)->where('FECHACREACION','=',$date)->update(['planificacion_id'=>$id]);
                   CP_DETALLEPLANIFICACION::where('operacion','=',$operacion)->where('FECHACREACION','=',$date)->update(['planificacion_id'=>$id]);
                   
                     



                      

                      $gannt2=DB::Connection()
                      ->select("select pl.fechaCalendariomin,pl.fechaCalendariomax,('ORDEN='+PL.ordenproduccion+'-'+'ARTICULO='+ART.ARTICULO+'-'+ART.DESCRIPCION) as text,SUBSTRING(pl.centrocosto,7,3) as cc,pl.centrocosto,pl.ordenproduccion 
                        from 
                        IBERPLAS.CP_PLANIFICACION pl, 
                        IBERPLAS.ARTICULO ART
                        WHERE 
                        PL.ARTICULO=ART.ARTICULO AND
                        pl.id='$id'" );
                      foreach ($gannt2 as $value) {
                       $fechai=date("d-m-Y H:i:s",strtotime($value->fechaCalendariomin));
                        $fechaf=date("d-m-Y H:i:s",strtotime($value->fechaCalendariomax));
                        $task=new CP_events;
                        $task->start_date=$fechai;
                        $task->end_date=$fechaf;
                        $task->text=$value->text;
                        $task->type_id=$value->cc;
                        $task->centrocosto=$value->centrocosto;
                        $task->ordenproduccion=$value->ordenproduccion;
                        $task->save(); 
                      }



                 }
                
              }



              

               
     return redirect()->route('planificador.index');
               //borrar cart
              
        
        
    }

  public function disponibilidadturnos($corre,$maquina)
  {
  
  }

  public function Ticket(){
    $TipoEquipo=DB::Connection()->select("SELECT TIPO_EQUIPO,DESCRIPCION FROM IBERPLAS.TIPO_EQUIPO 
    WHERE TIPO_EQUIPO IN (SELECT  
    EQ.TIPO_EQUIPO
    FROM 
    IBERPLAS.EQUIPO EQ,
    IBERPLAS.CP_PLANIFICACION PL
    WHERE EQ.EQUIPO=PL.centrocosto) ");

   


    
    $OrdenProduccion=CP_PLANIFICACION::all();
        return view('ControPiso.Consulta.Ticket')
               ->with('OrdenProduccion',$OrdenProduccion)
               ->with('TipoEquipo',$TipoEquipo);
  }

  public function consultaticket($id)
  {
    $cp_planificacion=CP_PLANIFICACION::where('id','=',$id)->get();
    $CP_ENCABEZADOPLANIFICACION=CP_ENCABEZADOPLANIFICACION::where('planificacion_id','=',$id)->get();
    $CP_DETALLEPLANIFICACION=CP_DETALLEPLANIFICACION::where('planificacion_id','=',$id)->get();

    return view('ControPiso.Consulta.ConsultaTicket')
           ->with('cp_planificacion',$cp_planificacion)
           ->with('cp_encabezadoplanificacion',$CP_ENCABEZADOPLANIFICACION)
           ->with('cp_detalleplanificacion',$CP_DETALLEPLANIFICACION);
  }

  public function eliminarTicket($id,$id1){
     
   $planificacion=CP_PLANIFICACION::where('ordenproduccion','=',$id1);
   $enca=CP_ENCABEZADOPLANIFICACION::where('ordenproduccion','=',$id1);
   $detalle=CP_DETALLEPLANIFICACION::where('ordenproduccion','=',$id1);
   
   $planificacion->delete();
   $enca->delete();
   $detalle->delete();
   $tasks=CP_tasks::where('ordenproduccion','=',$id1);
   $events=CP_events::where('ordenproduccion','=',$id1);
   $tasks->delete();
   $events->delete();
   CP_TCargaOrdenProduccion::where('ORDEN_PRODUCCION','=',$id1)->update(['CANTIDAD_PRODUCCI'=>0]);
   


   
   flash("Se ha eliminado la orden Produccion : ".$id1." de forma existosa",'danger')->important();
   return redirect()->route('Ticket');
  }

  public function viajero($id){
     $encabezado=DB::Connection()->select("select pro.ORDEN_PRODUCCION,pro.ARTICULO,art.DESCRIPCION,pro.CANTIDAD_ARTICULO,pro.FECHA_REQUERIDA,pro.REFERENCIa from IBERPLAS.ORDEN_PRODUCCION pro,IBERPLAS.ARTICULO art where pro.ORDEN_PRODUCCION='$id' and
       pro.ARTICULO=art.ARTICULO" );

      $detalle=DB::Connection()->select("select mate.ORDEN_PRODUCCION,mate.OPERACION,op.DESCRIPCION as des_op, mate.ARTICULO,art.DESCRIPCION, art.UNIDAD_ALMACEN, mate.CANTIDAD_ESTANDAR from 
        IBERPLAS.OP_OPER_CONSUMO mate,IBERPLAS.ARTICULO art ,IBERPLAS.OP_OPERACION OP
        where 
        mate.ORDEN_PRODUCCION='$id' and
        mate.ARTICULO=art.ARTICULO and
        mate.ORDEN_PRODUCCION=op.ORDEN_PRODUCCION and
        mate.OPERACION=op.OPERACION order by mate.operacion" );

      return view('ControPiso.Transacciones.viajero')
             ->with('encabezado',$encabezado)
             ->with('detalle',$detalle);

  }
    
}
