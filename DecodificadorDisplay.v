module DecodificadorDisplay(
    input [3:0] entrada, // [D C B A]
    output a,
    output b,
    output c,
    output d,
    output e,
    output f,
    output g
);

  // ---------- COMPLEMENTOS ----------
  wire nA, nB, nC, nD;
  not (nA, entrada[0]);
  not (nB, entrada[1]);
  not (nC, entrada[2]);
  not (nD, entrada[3]);

  // ---------- MINTERMS POR NÚMERO (0–9) ----------
  wire is0, is1, is2, is3, is4, is5, is6, is7, is8, is9;

  and (is0, nD, nC, nB, nA);                         // 0000 → 0
  and (is1, nD, nC, nB, entrada[0]);                 // 0001 → 1
  and (is2, nD, nC, entrada[1], nA);                 // 0010 → 2
  and (is3, nD, nC, entrada[1], entrada[0]);         // 0011 → 3
  and (is4, nD, entrada[2], nB, nA);                 // 0100 → 4
  and (is5, nD, entrada[2], nB, entrada[0]);         // 0101 → 5
  and (is6, nD, entrada[2], entrada[1], nA);         // 0110 → 6
  and (is7, nD, entrada[2], entrada[1], entrada[0]); // 0111 → 7
  and (is8, entrada[3], nC, nB, nA);                 // 1000 → 8
  and (is9, entrada[3], nC, nB, entrada[0]);         // 1001 → 9

  // ---------- SEGMENTOS (INVERTIDOS por causa que 0 ascende, 1 apaga) ----------
  wire a_temp, b_temp, c_temp, d_temp, e_temp, f_temp, g_temp;

  // Segmento A: 0,2,3,5,6,7,8,9
  or (a_temp, is0, is2, is3, is5, is6, is7, is8, is9);
  not (a, a_temp);

  // Segmento B: 0,1,2,3,4,7,8,9
  or (b_temp, is0, is1, is2, is3, is4, is7, is8, is9);
  not (b, b_temp);

  // Segmento C: 0,1,3,4,5,6,7,8,9
  or (c_temp, is0, is1, is3, is4, is5, is6, is7, is8, is9);
  not (c, c_temp);

  // Segmento D: 0,2,3,5,6,8,9
  or (d_temp, is0, is2, is3, is5, is6, is8, is9);
  not (d, d_temp);

  // Segmento E: 0,2,6,8
  or (e_temp, is0, is2, is6, is8);
  not (e, e_temp);

  // Segmento F: 0,4,5,6,8,9
  or (f_temp, is0, is4, is5, is6, is8, is9);
  not (f, f_temp);

  // Segmento G: 2,3,4,5,6,8,9
  or (g_temp, is2, is3, is4, is5, is6, is8, is9);
  not (g, g_temp);

endmodule
