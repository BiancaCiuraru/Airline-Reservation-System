package controller;

import javax.swing.*;
import java.awt.*;

public class PlataFrame extends JFrame {
    Plata plata;
    String nume, prenume, nrTel, dataNast, email1, adresa1, nationalitate1, tip1, gen1;

    public PlataFrame(String nume,String prenume, String nrTel, String dataNast,String email1,String adresa1,String nationalitate1,String tip1,String gen1 ) {
        super("Pay");
        this.nume = nume;
        this.prenume = prenume;
        this.nrTel = nrTel;
        this.dataNast = dataNast;
        this.email1 = email1;
        this.adresa1 = adresa1;
        this.nationalitate1 = nationalitate1;
        this.tip1 = tip1;
        this.gen1 = gen1;
        init();
    }

    private void init() {
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setPreferredSize(new Dimension(500, 400));
        setLayout( new BorderLayout() );
        plata = new Plata(this, nume, prenume, nrTel, dataNast, email1, adresa1, nationalitate1, tip1, gen1);
        add(plata,BorderLayout.CENTER);
        this.pack();
    }


}
